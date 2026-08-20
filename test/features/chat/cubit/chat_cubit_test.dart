import 'package:flutter_test/flutter_test.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/features/chat/cubit/chat_cubit.dart';
import 'package:clo_ai/features/chat/cubit/chat_state.dart';
import 'package:clo_ai/features/chat/domain/models/chat_model.dart';
import 'package:clo_ai/features/chat/domain/models/message_model.dart';
import 'package:clo_ai/features/chat/data/repositories/chat_repository.dart';

class MockChatRepository implements ChatRepository {
  bool shouldThrowError = false;
  String errorMessage = 'Failed to connect';

  final List<MessageModel> _messages = [
    const MessageModel(
      id: 'msg-1',
      chatId: 'chat-1',
      role: 'USER',
      content: 'Initial message',
    ),
  ];

  @override
  Future<ChatModel> getChat(String relationshipId) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    return ChatModel(
      id: 'chat-1',
      relationshipId: relationshipId,
      context: const RelationshipChatContext(
        name: 'Rahul',
        relationshipType: 'Friendship',
        category: 'Friends',
      ),
      messages: List.unmodifiable(_messages),
    );
  }

  @override
  Future<List<MessageModel>> getMessages(String relationshipId) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    return List.unmodifiable(_messages);
  }

  @override
  Future<MessageModel> sendMessage(
    String relationshipId,
    String content,
  ) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    final newMsg = MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      chatId: 'chat-1',
      role: 'USER',
      content: content,
    );
    _messages.add(newMsg);
    return newMsg;
  }

  @override
  Future<void> deleteChat(String relationshipId) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    _messages.clear();
  }
}

void main() {
  group('ChatCubit Unit Tests', () {
    late MockChatRepository repository;
    late ChatCubit cubit;

    setUp(() {
      repository = MockChatRepository();
      cubit = ChatCubit(repository: repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is ChatStatus.initial', () {
      expect(cubit.state.status, equals(ChatStatus.initial));
      expect(cubit.state.messages, isEmpty);
    });

    test('loadChat emits ChatStatus.loading then ChatStatus.loaded', () async {
      await cubit.loadChat('rel-1');

      expect(cubit.state.status, equals(ChatStatus.loaded));
      expect(cubit.state.relationshipId, equals('rel-1'));
      expect(cubit.state.messages.length, equals(1));
      expect(cubit.state.chat?.context?.name, equals('Rahul'));
    });

    test(
      'loadChat handles ApiException by emitting ChatStatus.error',
      () async {
        repository.shouldThrowError = true;
        await cubit.loadChat('rel-1');

        expect(cubit.state.status, equals(ChatStatus.error));
        expect(cubit.state.errorMessage, equals('Failed to connect'));
      },
    );

    test(
      'sendMessage optimistically appends message and replaces with server response',
      () async {
        await cubit.loadChat('rel-1');
        expect(cubit.state.messages.length, equals(1));

        await cubit.sendMessage('Hello Rahul');

        expect(cubit.state.isSending, isFalse);
        expect(cubit.state.messages.length, equals(2));
        expect(cubit.state.messages.last.content, equals('Hello Rahul'));
      },
    );

    test('sendMessage handles send failure', () async {
      await cubit.loadChat('rel-1');
      repository.shouldThrowError = true;

      await cubit.sendMessage('Failed text');

      expect(cubit.state.isSending, isFalse);
      expect(cubit.state.errorMessage, equals('Failed to connect'));
    });

    test('deleteChat clears conversation messages', () async {
      await cubit.loadChat('rel-1');
      expect(cubit.state.messages, isNotEmpty);

      await cubit.deleteChat();

      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.chat, isNull);
    });
  });
}
