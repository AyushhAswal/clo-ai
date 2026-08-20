import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/core/storage/token_storage.dart';
import 'package:clo_ai/features/auth/cubit/auth_cubit.dart';
import 'package:clo_ai/features/auth/cubit/auth_state.dart';
import 'package:clo_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTokenStorage extends TokenStorage {
  String? _storedToken;

  @override
  Future<void> saveToken(String token) async {
    _storedToken = token;
  }

  @override
  Future<String?> getToken() async {
    return _storedToken;
  }

  @override
  Future<void> clearToken() async {
    _storedToken = null;
  }
}

class FakeAdapter implements HttpClientAdapter {
  late ResponsePayload Function(RequestOptions options) onRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final payload = onRequest(options);
    return ResponseBody.fromString(
      payload.body,
      payload.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class ResponsePayload {
  final int statusCode;
  final String body;

  ResponsePayload(this.statusCode, this.body);
}

void main() {
  late ApiClient apiClient;
  late FakeAdapter fakeAdapter;
  late MockTokenStorage mockTokenStorage;
  late AuthRepository authRepository;

  beforeEachSetup() {
    fakeAdapter = FakeAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
    dio.httpClientAdapter = fakeAdapter;

    apiClient = ApiClient(dio: dio);
    mockTokenStorage = MockTokenStorage();
    authRepository = AuthRepository(
      apiClient: apiClient,
      tokenStorage: mockTokenStorage,
    );
  }

  setUp(() {
    beforeEachSetup();
  });

  group('AuthRepository Unit Tests', () {
    test('Successful register saves token and returns UserAuthModel', () async {
      fakeAdapter.onRequest = (options) {
        expect(options.path, equals('/auth/register'));
        return ResponsePayload(
          201,
          '{"user":{"id":"user-123","name":"Ayush","email":"ayush@example.com"},"accessToken":"test-jwt-token"}',
        );
      };

      final user = await authRepository.register(
        name: 'Ayush',
        email: 'ayush@example.com',
        password: 'password123',
      );

      expect(user.id, equals('user-123'));
      expect(user.name, equals('Ayush'));
      expect(await mockTokenStorage.getToken(), equals('test-jwt-token'));
      expect(apiClient.isAuthenticated, isTrue);
    });

    test('Successful login saves token and returns UserAuthModel', () async {
      fakeAdapter.onRequest = (options) {
        expect(options.path, equals('/auth/login'));
        return ResponsePayload(
          200,
          '{"user":{"id":"user-123","name":"Ayush","email":"ayush@example.com"},"accessToken":"test-jwt-token"}',
        );
      };

      final user = await authRepository.login(
        email: 'ayush@example.com',
        password: 'password123',
      );

      expect(user.id, equals('user-123'));
      expect(await mockTokenStorage.getToken(), equals('test-jwt-token'));
      expect(apiClient.isAuthenticated, isTrue);
    });

    test('Failed login throws ApiException', () async {
      fakeAdapter.onRequest = (options) {
        return ResponsePayload(
          401,
          '{"statusCode":401,"message":"Invalid credentials"}',
        );
      };

      expect(
        () =>
            authRepository.login(email: 'ayush@example.com', password: 'wrong'),
        throwsA(isA<ApiException>()),
      );
    });

    test('restoreSession with valid stored token', () async {
      await mockTokenStorage.saveToken('valid-token');

      fakeAdapter.onRequest = (options) {
        expect(options.path, equals('/auth/me'));
        expect(options.headers['Authorization'], equals('Bearer valid-token'));
        return ResponsePayload(
          200,
          '{"id":"user-123","name":"Ayush","email":"ayush@example.com"}',
        );
      };

      final user = await authRepository.restoreSession();
      expect(user, isNotNull);
      expect(user!.email, equals('ayush@example.com'));
    });

    test('restoreSession with invalid token clears storage', () async {
      await mockTokenStorage.saveToken('invalid-token');

      fakeAdapter.onRequest = (options) {
        return ResponsePayload(
          401,
          '{"statusCode":401,"message":"Unauthorized"}',
        );
      };

      final user = await authRepository.restoreSession();
      expect(user, isNull);
      expect(await mockTokenStorage.getToken(), isNull);
      expect(apiClient.isAuthenticated, isFalse);
    });
  });

  group('AuthCubit State Tests', () {
    test(
      'checkSession emits AuthAuthenticated when valid token restored',
      () async {
        await mockTokenStorage.saveToken('valid-token');
        fakeAdapter.onRequest = (options) {
          return ResponsePayload(
            200,
            '{"id":"user-123","name":"Ayush","email":"ayush@example.com"}',
          );
        };

        final authCubit = AuthCubit(repository: authRepository);
        await authCubit.checkSession();

        expect(authCubit.state, isA<AuthAuthenticated>());
        final state = authCubit.state as AuthAuthenticated;
        expect(state.user.name, equals('Ayush'));
      },
    );

    test(
      'checkSession emits AuthUnauthenticated when no token stored',
      () async {
        final authCubit = AuthCubit(repository: authRepository);
        await authCubit.checkSession();

        expect(authCubit.state, isA<AuthUnauthenticated>());
      },
    );

    test('login emits AuthAuthenticated on success', () async {
      fakeAdapter.onRequest = (options) {
        return ResponsePayload(
          200,
          '{"user":{"id":"user-123","name":"Ayush","email":"ayush@example.com"},"accessToken":"jwt-token"}',
        );
      };

      final authCubit = AuthCubit(repository: authRepository);
      await authCubit.login(
        email: 'ayush@example.com',
        password: 'password123',
      );

      expect(authCubit.state, isA<AuthAuthenticated>());
    });

    test('login emits AuthUnauthenticated with error message on 401', () async {
      fakeAdapter.onRequest = (options) {
        return ResponsePayload(
          401,
          '{"statusCode":401,"message":"Invalid credentials"}',
        );
      };

      final authCubit = AuthCubit(repository: authRepository);
      await authCubit.login(email: 'ayush@example.com', password: 'wrong');

      expect(authCubit.state, isA<AuthUnauthenticated>());
      final state = authCubit.state as AuthUnauthenticated;
      expect(state.errorMessage, equals('Invalid credentials'));
    });

    test('logout clears session and emits AuthUnauthenticated', () async {
      await mockTokenStorage.saveToken('some-token');

      final authCubit = AuthCubit(repository: authRepository);
      await authCubit.logout();

      expect(authCubit.state, isA<AuthUnauthenticated>());
      expect(await mockTokenStorage.getToken(), isNull);
    });
  });
}
