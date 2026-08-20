class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final String? relationshipType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.relationshipType,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(
    Map<String, dynamic> json, {
    String? personName,
  }) {
    final String type = json['relationshipType'] as String? ?? '';
    final List<String> parsedOptions = _getDefaultOptionsForType(
      type,
      personName: personName,
    );

    return QuestionModel(
      id: json['id'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      options: json['options'] != null
          ? List<String>.from(json['options'] as List)
          : parsedOptions,
      relationshipType: type,
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
      'questionText': questionText,
      'options': options,
      if (relationshipType != null) 'relationshipType': relationshipType,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  static List<String> _getDefaultOptionsForType(
    String type, {
    String? personName,
  }) {
    final String lower = type.toLowerCase();
    if (lower.contains('friend')) {
      return const [
        'Close, and it feels solid.',
        'New — still getting closer.',
        "Changed — we care, but the rhythm's off.",
        "Uneven — I give more, or something's unsaid.",
      ];
    } else if (lower.contains('romantic')) {
      return const [
        'Flourishing — deeply connected and aligned.',
        'Stable — comfortable, but missing spark.',
        'Tense — frequent friction and misunderstandings.',
        'Uncertain — questioning long-term harmony.',
      ];
    } else if (lower.contains('professional')) {
      return const [
        'Highly collaborative & effective',
        'Professional but distant',
        'Frictional — communication barriers exist',
        'Hierarchical tension or misalignment',
      ];
    } else {
      return const [
        'Close and supportive',
        'Traditional — bonded by duty',
        'Complicated — unresolved past issues',
        'Distant — rarely communicating deeply',
      ];
    }
  }
}

typedef RelationshipQuestionModel = QuestionModel;
