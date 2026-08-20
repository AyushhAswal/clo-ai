import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:clo_ai/core/network/api_client.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/features/chat/data/repositories/chat_repository.dart';
import '../../../home/data/repositories/relationship_repository_test.dart';

void main() {
  group('ApiChatRepository Unit Tests', () {
    late MockDio mockDio;
    late ApiClient apiClient;
    late ApiChatRepository repository;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(dio: mockDio);
      repository = ApiChatRepository(apiClient: apiClient);
    });

    test('getChat parses chat model and questionnaire context', () async {
      mockDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: '/chats/rel-1'),
        statusCode: 200,
        data: {
          'id': 'chat-1',
          'relationshipId': 'rel-1',
          'context': {
            'relationship': {
              'name': 'Rahul',
              'relationshipType': 'Friendship',
              'category': 'Friends',
            },
            'questionnaire': [
              {
                'questionText': "Where's your friendship at?",
                'answer': 'Close and solid',
              },
            ],
          },
          'messages': [
            {
              'id': 'msg-1',
              'chatId': 'chat-1',
              'role': 'USER',
              'content': 'Hello Rahul',
            },
          ],
        },
      );

      final chat = await repository.getChat('rel-1');
      expect(chat.id, equals('chat-1'));
      expect(chat.relationshipId, equals('rel-1'));
      expect(chat.context?.name, equals('Rahul'));
      expect(chat.context?.questionnaire.length, equals(1));
      expect(chat.messages.length, equals(1));
    });

    test('getMessages parses list of messages', () async {
      mockDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: '/chats/rel-1/messages'),
        statusCode: 200,
        data: [
          {
            'id': 'msg-1',
            'chatId': 'chat-1',
            'role': 'USER',
            'content': 'First message',
          },
          {
            'id': 'msg-2',
            'chatId': 'chat-1',
            'role': 'ASSISTANT',
            'content': 'Second message',
          },
        ],
      );

      final messages = await repository.getMessages('rel-1');
      expect(messages.length, equals(2));
      expect(messages[0].isUserMessage, isTrue);
      expect(messages[1].isUserMessage, isFalse);
    });

    test(
      'sendMessage posts user message content and returns created MessageModel',
      () async {
        mockDio.responseToReturn = Response(
          requestOptions: RequestOptions(path: '/chats/rel-1/messages'),
          statusCode: 201,
          data: {
            'id': 'msg-10',
            'chatId': 'chat-1',
            'role': 'USER',
            'content': 'Hello from test',
          },
        );

        final message = await repository.sendMessage(
          'rel-1',
          'Hello from test',
        );
        expect(message.id, equals('msg-10'));
        expect(message.content, equals('Hello from test'));
        expect(message.isUserMessage, isTrue);
      },
    );

    test('deleteChat calls delete endpoint on ApiClient', () async {
      mockDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: '/chats/rel-1'),
        statusCode: 200,
        data: {'message': 'Chat deleted successfully'},
      );

      await expectLater(repository.deleteChat('rel-1'), completes);
    });

    test('Throws ApiException when DioException occurs', () async {
      mockDio.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/chats/rel-1'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/chats/rel-1'),
          statusCode: 403,
          data: {'statusCode': 403, 'message': 'Forbidden'},
        ),
      );

      expect(
        () async => await repository.getChat('rel-1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
