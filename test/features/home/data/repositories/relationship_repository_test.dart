import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/features/home/data/repositories/relationship_repository.dart';
import 'package:clo_ai/features/relationship/domain/models/relationship_answer_model.dart';

class MockDio extends Fake implements Dio {
  late Response responseToReturn;
  DioException? exceptionToThrow;

  @override
  Interceptors get interceptors => Interceptors();

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn as Response<T>;
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn as Response<T>;
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn as Response<T>;
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn as Response<T>;
  }
}

void main() {
  group('ApiRelationshipRepository Unit Tests', () {
    late MockDio mockDio;
    late ApiClient apiClient;
    late ApiRelationshipRepository repository;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(dio: mockDio);
      repository = ApiRelationshipRepository(apiClient: apiClient);
    });

    test(
      'getRelationships parses list of relationships from API response',
      () async {
        mockDio.responseToReturn = Response(
          requestOptions: RequestOptions(path: '/relationships'),
          statusCode: 200,
          data: [
            {
              'id': 'rel-1',
              'name': 'Rahul',
              'relationshipType': 'Friendship',
              'category': 'Friends',
              'answers': [],
            },
          ],
        );

        final result = await repository.getRelationships(category: 'Friends');
        expect(result.length, equals(1));
        expect(result.first.name, equals('Rahul'));
        expect(result.first.category, equals('Friends'));
      },
    );

    test('getQuestions parses question templates from API response', () async {
      mockDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: '/relationships/questions'),
        statusCode: 200,
        data: [
          {
            'id': 'q-1',
            'questionText': "Where's your friendship at?",
            'relationshipType': 'Friendship',
          },
        ],
      );

      final result = await repository.getQuestions(
        relationshipType: 'Friendship',
      );
      expect(result.length, equals(1));
      expect(result.first.questionText, equals("Where's your friendship at?"));
    });

    test(
      'createRelationship posts relationship and parses created response',
      () async {
        mockDio.responseToReturn = Response(
          requestOptions: RequestOptions(path: '/relationships'),
          statusCode: 201,
          data: {
            'id': 'rel-100',
            'name': 'Sarah',
            'relationshipType': 'Friendship',
            'category': 'Friends',
            'photoUrl': null,
            'answers': [
              {
                'id': 'ans-1',
                'relationshipId': 'rel-100',
                'questionId': 'q-1',
                'questionText': "Where's your friendship at?",
                'answer': 'Close and solid',
              },
            ],
          },
        );

        final result = await repository.createRelationship(
          name: 'Sarah',
          relationshipType: 'Friendship',
          category: 'Friends',
          photoUrl: null,
          answers: const [
            RelationshipAnswerRequest(
              questionId: 'q-1',
              questionText: "Where's your friendship at?",
              answer: 'Close and solid',
            ),
          ],
        );

        expect(result.id, equals('rel-100'));
        expect(result.name, equals('Sarah'));
        expect(result.answers.length, equals(1));
      },
    );

    test('Throws ApiException when DioException occurs', () async {
      mockDio.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/relationships'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () async => await repository.getRelationships(),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
