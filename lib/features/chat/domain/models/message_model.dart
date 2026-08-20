class MessageModel {
  final String id;
  final String chatId;
  final String role; // 'USER' | 'ASSISTANT'
  final String content;
  final DateTime? createdAt;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    this.createdAt,
  });

  bool get isUserMessage => role == 'USER';

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'role': role,
      'content': content,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
