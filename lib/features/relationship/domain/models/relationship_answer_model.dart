class RelationshipAnswerModel {
  final String id;
  final String relationshipId;
  final String questionId;
  final String questionText;
  final String answer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RelationshipAnswerModel({
    required this.id,
    required this.relationshipId,
    required this.questionId,
    required this.questionText,
    required this.answer,
    this.createdAt,
    this.updatedAt,
  });

  factory RelationshipAnswerModel.fromJson(Map<String, dynamic> json) {
    return RelationshipAnswerModel(
      id: json['id'] as String? ?? '',
      relationshipId: json['relationshipId'] as String? ?? '',
      questionId: json['questionId'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relationshipId': relationshipId,
      'questionId': questionId,
      'questionText': questionText,
      'answer': answer,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class RelationshipAnswerRequest {
  final String questionId;
  final String questionText;
  final String answer;

  const RelationshipAnswerRequest({
    required this.questionId,
    required this.questionText,
    required this.answer,
  });

  factory RelationshipAnswerRequest.fromJson(Map<String, dynamic> json) {
    return RelationshipAnswerRequest(
      questionId: json['questionId'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'answer': answer,
    };
  }
}
