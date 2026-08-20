import 'message_model.dart';

class PersonalChatModel {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageModel> messages;

  const PersonalChatModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory PersonalChatModel.fromJson(Map<String, dynamic> json) {
    return PersonalChatModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      messages: json['messages'] != null
          ? (json['messages'] as List)
                .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}
