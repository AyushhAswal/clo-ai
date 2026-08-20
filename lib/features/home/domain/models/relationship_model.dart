import '../../../relationship/domain/models/relationship_answer_model.dart';

class RelationshipModel {
  final String id;
  final String? userId;
  final String name;
  final String relationshipType;
  final String category;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<RelationshipAnswerModel> answers;

  const RelationshipModel({
    required this.id,
    this.userId,
    required this.name,
    required this.relationshipType,
    required this.category,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.answers = const [],
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : 'A';

  factory RelationshipModel.fromJson(Map<String, dynamic> json) {
    return RelationshipModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? '',
      relationshipType: json['relationshipType'] as String? ?? '',
      category: json['category'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      answers: json['answers'] != null
          ? (json['answers'] as List)
                .map(
                  (e) => RelationshipAnswerModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (userId != null) 'userId': userId,
      'name': name,
      'relationshipType': relationshipType,
      'category': category,
      'photoUrl': photoUrl,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}
