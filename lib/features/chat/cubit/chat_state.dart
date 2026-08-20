import '../domain/models/chat_model.dart';
import '../domain/models/message_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState {
  final ChatStatus status;
  final ChatModel? chat;
  final List<MessageModel> messages;
  final String? relationshipId;
  final String? errorMessage;
  final bool isSending;
  final bool isDeleting;

  const ChatState({
    this.status = ChatStatus.initial,
    this.chat,
    this.messages = const [],
    this.relationshipId,
    this.errorMessage,
    this.isSending = false,
    this.isDeleting = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    ChatModel? chat,
    bool clearChat = false,
    List<MessageModel>? messages,
    String? relationshipId,
    String? errorMessage,
    bool? isSending,
    bool? isDeleting,
  }) {
    return ChatState(
      status: status ?? this.status,
      chat: clearChat ? null : (chat ?? this.chat),
      messages: messages ?? this.messages,
      relationshipId: relationshipId ?? this.relationshipId,
      errorMessage: errorMessage,
      isSending: isSending ?? this.isSending,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
