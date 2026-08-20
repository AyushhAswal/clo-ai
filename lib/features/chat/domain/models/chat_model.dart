import 'message_model.dart';

class QuestionnaireContextItem {
  final String questionText;
  final String answer;

  const QuestionnaireContextItem({
    required this.questionText,
    required this.answer,
  });

  factory QuestionnaireContextItem.fromJson(Map<String, dynamic> json) {
    return QuestionnaireContextItem(
      questionText: json['questionText'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'questionText': questionText, 'answer': answer};
  }
}

class RelationshipChatContext {
  final String name;
  final String relationshipType;
  final String category;
  final List<QuestionnaireContextItem> questionnaire;

  const RelationshipChatContext({
    required this.name,
    required this.relationshipType,
    required this.category,
    this.questionnaire = const [],
  });

  factory RelationshipChatContext.fromJson(Map<String, dynamic> json) {
    final rel = json['relationship'] as Map<String, dynamic>? ?? {};
    final list = json['questionnaire'] as List? ?? [];

    return RelationshipChatContext(
      name: rel['name'] as String? ?? '',
      relationshipType: rel['relationshipType'] as String? ?? '',
      category: rel['category'] as String? ?? '',
      questionnaire: list
          .map(
            (e) => QuestionnaireContextItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationship': {
        'name': name,
        'relationshipType': relationshipType,
        'category': category,
      },
      'questionnaire': questionnaire.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatModel {
  final String id;
  final String relationshipId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RelationshipChatContext? context;
  final List<MessageModel> messages;

  const ChatModel({
    required this.id,
    required this.relationshipId,
    this.createdAt,
    this.updatedAt,
    this.context,
    this.messages = const [],
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String? ?? '',
      relationshipId: json['relationshipId'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      context: json['context'] != null
          ? RelationshipChatContext.fromJson(
              json['context'] as Map<String, dynamic>,
            )
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
                .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relationshipId': relationshipId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (context != null) 'context': context!.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}
