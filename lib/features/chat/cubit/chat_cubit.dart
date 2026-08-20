import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_exception.dart';
import '../data/repositories/chat_repository.dart';
import '../domain/models/message_model.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({ChatRepository? repository})
    : repository = repository ?? ApiChatRepository(),
      super(const ChatState());

  Future<void> loadChat(String relationshipId) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        relationshipId: relationshipId,
        errorMessage: null,
      ),
    );

    try {
      final chat = await repository.getChat(relationshipId);
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          chat: chat,
          messages: chat.messages,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.relationshipId == null) return;
    if (state.isSending) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = MessageModel(
      id: tempId,
      chatId: state.chat?.id ?? '',
      role: 'USER',
      content: trimmed,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...state.messages, tempMessage];
    emit(
      state.copyWith(
        messages: updatedMessages,
        isSending: true,
        errorMessage: null,
      ),
    );

    try {
      final serverMessage = await repository.sendMessage(
        state.relationshipId!,
        trimmed,
      );

      final List<MessageModel> finalMessages = [];
      for (final m in state.messages) {
        if (m.id == tempId) {
          if (serverMessage.isUserMessage) {
            finalMessages.add(serverMessage);
          } else {
            finalMessages.add(
              MessageModel(
                id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                chatId: serverMessage.chatId,
                role: 'USER',
                content: trimmed,
                createdAt: tempMessage.createdAt,
              ),
            );
          }
        } else {
          finalMessages.add(m);
        }
      }

      if (!serverMessage.isUserMessage) {
        finalMessages.add(serverMessage);
      }

      emit(state.copyWith(messages: finalMessages, isSending: false));
    } on ApiException catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteChat() async {
    if (state.relationshipId == null) return;

    emit(state.copyWith(isDeleting: true, errorMessage: null));

    try {
      await repository.deleteChat(state.relationshipId!);
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          clearChat: true,
          messages: const [],
          isDeleting: false,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: e.toString()));
    }
  }
}
