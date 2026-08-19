class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final String relationshipType;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.relationshipType,
  });
}
