import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/personal_chat_repository.dart';
import '../domain/models/message_model.dart';
import 'personal_chat_state.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  final PersonalChatRepository _repository;

  PersonalChatCubit({PersonalChatRepository? repository})
    : _repository = repository ?? PersonalChatRepository(),
      super(const PersonalChatState());

  /// Loads or creates the authenticated user's single persistent PersonalChat session.
  Future<void> loadPersonalChat() async {
    emit(state.copyWith(status: PersonalChatStatus.loading));

    try {
      final personalChat = await _repository.getOrCreatePersonalChat();
      emit(
        state.copyWith(
          status: PersonalChatStatus.loaded,
          personalChat: personalChat,
          messages: personalChat.messages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PersonalChatStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Sends a user message to Personal Chat, appends it optimistically, and fetches the AI response.
  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final userMessage = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      chatId: state.personalChat?.id ?? '',
      role: 'USER',
      content: trimmed,
      createdAt: DateTime.now(),
    );

    final updatedMessages = List<MessageModel>.from(state.messages)
      ..add(userMessage);

    emit(state.copyWith(messages: updatedMessages, isSending: true));

    try {
      final assistantMessage = await _repository.sendMessage(trimmed);
      final finalMessages = List<MessageModel>.from(state.messages)
        ..add(assistantMessage);

      emit(state.copyWith(messages: finalMessages, isSending: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSending: false,
          errorMessage: 'Failed to send message: $e',
        ),
      );
    }
  }
}
