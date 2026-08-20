import 'package:flutter_test/flutter_test.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/features/home/cubit/my_circle_cubit.dart';
import 'package:clo_ai/features/home/cubit/my_circle_state.dart';
import 'package:clo_ai/features/home/domain/models/relationship_model.dart';
import 'package:clo_ai/features/home/data/repositories/relationship_repository.dart';
import 'package:clo_ai/features/relationship/domain/models/question_model.dart';
import 'package:clo_ai/features/relationship/domain/models/relationship_answer_model.dart';

class MockRelationshipRepository implements RelationshipRepository {
  final List<RelationshipModel> _items = [
    const RelationshipModel(
      id: '1',
      name: 'Ayush',
      relationshipType: 'Professional',
      category: 'Professional',
    ),
    const RelationshipModel(
      id: '2',
      name: 'Rahul',
      relationshipType: 'Friendship',
      category: 'Friends',
    ),
    const RelationshipModel(
      id: '3',
      name: 'Neha',
      relationshipType: 'Family',
      category: 'Family',
    ),
    const RelationshipModel(
      id: '4',
      name: 'Someone',
      relationshipType: 'Romantic',
      category: 'Romantic',
    ),
  ];

  bool shouldThrowError = false;
  String errorMessage = 'API Connection Error';

  @override
  Future<List<RelationshipModel>> getRelationships({String? category}) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    if (category != null && category != 'All') {
      return _items.where((element) => element.category == category).toList();
    }
    return List.unmodifiable(_items);
  }

  @override
  Future<RelationshipModel> getRelationship(String id) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    return _items.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<RelationshipQuestionModel>> getQuestions({
    String? relationshipType,
  }) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    return [
      QuestionModel(
        id: 'q1',
        questionText: "Where's your friendship at?",
        options: const ['Close, and it feels solid.'],
        relationshipType: relationshipType ?? 'Friendship',
      ),
    ];
  }

  @override
  Future<RelationshipModel> createRelationship({
    required String name,
    required String relationshipType,
    required String category,
    String? photoUrl,
    required List<RelationshipAnswerRequest> answers,
  }) async {
    if (shouldThrowError) {
      throw ApiException(message: errorMessage);
    }
    final newRel = RelationshipModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      relationshipType: relationshipType,
      category: category,
      photoUrl: photoUrl,
      answers: answers
          .map(
            (a) => RelationshipAnswerModel(
              id: 'ans-1',
              relationshipId: 'rel-1',
              questionId: a.questionId,
              questionText: a.questionText,
              answer: a.answer,
            ),
          )
          .toList(),
    );
    _items.add(newRel);
    return newRel;
  }

  @override
  Future<RelationshipModel> updateRelationship({
    required String id,
    String? name,
    String? relationshipType,
    String? category,
    String? photoUrl,
    List<RelationshipAnswerRequest>? answers,
  }) async {
    final index = _items.indexWhere((element) => element.id == id);
    final existing = _items[index];
    final updated = RelationshipModel(
      id: existing.id,
      name: name ?? existing.name,
      relationshipType: relationshipType ?? existing.relationshipType,
      category: category ?? existing.category,
      photoUrl: photoUrl ?? existing.photoUrl,
    );
    _items[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteRelationship(String id) async {
    _items.removeWhere((element) => element.id == id);
  }
}

void main() {
  group('MyCircleCubit Unit Tests', () {
    late MockRelationshipRepository repository;
    late MyCircleCubit cubit;

    setUp(() {
      repository = MockRelationshipRepository();
      cubit = MyCircleCubit(repository: repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state fetches and loads relationships', () async {
      await cubit.loadRelationships();
      expect(cubit.state.status, MyCircleStatus.loaded);
      expect(cubit.state.relationships.length, equals(4));

      final names = cubit.state.relationships.map((e) => e.name).toList();
      expect(names, containsAll(['Ayush', 'Rahul', 'Neha', 'Someone']));
    });

    test('Handles API exception gracefully by emitting error status', () async {
      repository.shouldThrowError = true;
      await cubit.loadRelationships();

      expect(cubit.state.status, MyCircleStatus.error);
      expect(cubit.state.errorMessage, equals('API Connection Error'));
    });

    test('Category filtering works correctly', () async {
      await cubit.loadRelationships();
      cubit.selectCategory('Friends');

      expect(cubit.state.selectedCategory, equals('Friends'));
      expect(
        cubit.state.filteredRelationships.every(
          (e) => e.category == 'Friends' || e.relationshipType == 'Friendship',
        ),
        isTrue,
      );
      expect(
        cubit.state.filteredRelationships.any((e) => e.name == 'Rahul'),
        isTrue,
      );

      cubit.selectCategory('Professional');
      expect(
        cubit.state.filteredRelationships.every(
          (e) => e.category == 'Professional',
        ),
        isTrue,
      );
      expect(
        cubit.state.filteredRelationships.any((e) => e.name == 'Ayush'),
        isTrue,
      );
    });

    test('Search query filtering works correctly', () async {
      await cubit.loadRelationships();
      cubit.selectCategory('All');
      cubit.setSearchQuery('rah');

      expect(cubit.state.filteredRelationships.length, equals(1));
      expect(cubit.state.filteredRelationships.first.name, equals('Rahul'));
    });
  });
}
