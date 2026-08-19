class RelationshipModel {
  final String id;
  final String name;
  final String
  relationshipType; // e.g. 'Professional', 'Friendship', 'Romantic', 'Family'
  final String category; // e.g. 'Professional', 'Friends', 'Romantic', 'Family'
  final String? photoUrl;

  const RelationshipModel({
    required this.id,
    required this.name,
    required this.relationshipType,
    required this.category,
    this.photoUrl,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : 'A';
}
