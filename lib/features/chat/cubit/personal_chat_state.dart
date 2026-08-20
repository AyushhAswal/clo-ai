import '../domain/models/message_model.dart';
import '../domain/models/personal_chat_model.dart';

enum PersonalChatStatus { initial, loading, loaded, sending, error }

class PersonalChatState {
  final PersonalChatStatus status;
  final PersonalChatModel? personalChat;
  final List<MessageModel> messages;
  final String? errorMessage;
  final bool isSending;

  const PersonalChatState({
    this.status = PersonalChatStatus.initial,
    this.personalChat,
    this.messages = const [],
    this.errorMessage,
    this.isSending = false,
  });

  PersonalChatState copyWith({
    PersonalChatStatus? status,
    PersonalChatModel? personalChat,
    List<MessageModel>? messages,
    String? errorMessage,
    bool? isSending,
  }) {
    return PersonalChatState(
      status: status ?? this.status,
      personalChat: personalChat ?? this.personalChat,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      isSending: isSending ?? this.isSending,
    );
  }
}
