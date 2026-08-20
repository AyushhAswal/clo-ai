import '../domain/models/relationship_model.dart';

enum MyCircleStatus { initial, loading, loaded, error }

class MyCircleState {
  final MyCircleStatus status;
  final List<RelationshipModel> relationships;
  final String selectedCategory;
  final String searchQuery;
  final bool isSearching;
  final String? errorMessage;

  const MyCircleState({
    this.status = MyCircleStatus.initial,
    this.relationships = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.isSearching = false,
    this.errorMessage,
  });

  List<RelationshipModel> get filteredRelationships {
    return relationships.where((item) {
      bool matchesCategory = true;
      if (selectedCategory != 'All') {
        if (selectedCategory == 'Friends') {
          matchesCategory =
              item.category == 'Friends' ||
              item.relationshipType.toLowerCase().contains('friend');
        } else {
          matchesCategory =
              item.category.toLowerCase() == selectedCategory.toLowerCase();
        }
      }

      bool matchesSearch = true;
      if (searchQuery.trim().isNotEmpty) {
        matchesSearch = item.name.toLowerCase().contains(
          searchQuery.trim().toLowerCase(),
        );
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  MyCircleState copyWith({
    MyCircleStatus? status,
    List<RelationshipModel>? relationships,
    String? selectedCategory,
    String? searchQuery,
    bool? isSearching,
    String? errorMessage,
  }) {
    return MyCircleState(
      status: status ?? this.status,
      relationships: relationships ?? this.relationships,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
