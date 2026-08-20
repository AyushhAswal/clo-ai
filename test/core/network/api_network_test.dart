import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/core/network/api_config.dart';
import 'package:clo_ai/core/network/api_endpoints.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiConfig Tests', () {
    test('Environment base URL resolution', () {
      ApiConfig.environment = ApiEnvironment.local;
      expect(ApiConfig.baseUrl, equals('http://10.0.2.2:3000'));

      ApiConfig.environment = ApiEnvironment.dev;
      expect(ApiConfig.baseUrl, equals('https://dev-api.clo.ai'));

      ApiConfig.environment = ApiEnvironment.prod;
      expect(ApiConfig.baseUrl, equals('https://api.clo.ai'));

      // Reset to local
      ApiConfig.environment = ApiEnvironment.local;
    });

    test('Timeout values configuration', () {
      expect(ApiConfig.connectTimeout, equals(const Duration(seconds: 15)));
      expect(ApiConfig.receiveTimeout, equals(const Duration(seconds: 15)));
      expect(ApiConfig.sendTimeout, equals(const Duration(seconds: 15)));
    });
  });

  group('ApiEndpoints Tests', () {
    test('Authentication endpoint paths', () {
      expect(ApiEndpoints.authPrefix, equals('/auth'));
      expect(ApiEndpoints.auth.register, equals('/auth/register'));
      expect(ApiEndpoints.auth.login, equals('/auth/login'));
      expect(ApiEndpoints.auth.me, equals('/auth/me'));
    });
  });

  group('ApiClient Tests', () {
    test('ApiClient initialization with default ApiConfig', () {
      ApiConfig.environment = ApiEnvironment.local;
      final apiClient = ApiClient();

      expect(apiClient.dio.options.baseUrl, equals('http://10.0.2.2:3000'));
      expect(
        apiClient.dio.options.connectTimeout,
        equals(const Duration(seconds: 15)),
      );
      expect(
        apiClient.dio.options.headers['Content-Type'],
        equals('application/json'),
      );
      expect(
        apiClient.dio.options.headers['Accept'],
        equals('application/json'),
      );
    });

    test('Auth token management in ApiClient', () {
      final apiClient = ApiClient();
      expect(apiClient.isAuthenticated, isFalse);

      apiClient.setAuthToken('sample-test-jwt-token');
      expect(apiClient.isAuthenticated, isTrue);

      apiClient.clearAuthToken();
      expect(apiClient.isAuthenticated, isFalse);
    });
  });

  group('ApiException Tests', () {
    test('Connection timeout mapping', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );
      final apiException = ApiException.fromDioException(dioException);

      expect(apiException.message, contains('Connection timeout'));
    });

    test('HTTP 401 Unauthorized mapping', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          statusCode: 401,
          data: {'message': 'Unauthorized'},
        ),
      );
      final apiException = ApiException.fromDioException(dioException);

      expect(apiException.statusCode, equals(401));
      expect(apiException.message, equals('Unauthorized'));
    });

    test('HTTP 409 Conflict mapping', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/register'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/register'),
          statusCode: 409,
          data: {'message': 'User with this email already exists'},
        ),
      );
      final apiException = ApiException.fromDioException(dioException);

      expect(apiException.statusCode, equals(409));
      expect(
        apiException.message,
        equals('User with this email already exists'),
      );
    });
  });
}
