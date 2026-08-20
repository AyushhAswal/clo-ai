import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../relationship/domain/models/question_model.dart';
import '../../../relationship/domain/models/relationship_answer_model.dart';
import '../../domain/models/relationship_model.dart';

abstract class RelationshipRepository {
  Future<List<RelationshipModel>> getRelationships({String? category});

  Future<RelationshipModel> getRelationship(String id);

  Future<List<RelationshipQuestionModel>> getQuestions({
    String? relationshipType,
  });

  Future<RelationshipModel> createRelationship({
    required String name,
    required String relationshipType,
    required String category,
    String? photoUrl,
    required List<RelationshipAnswerRequest> answers,
  });

  Future<RelationshipModel> updateRelationship({
    required String id,
    String? name,
    String? relationshipType,
    String? category,
    String? photoUrl,
    List<RelationshipAnswerRequest>? answers,
  });

  Future<void> deleteRelationship(String id);
}

class ApiRelationshipRepository implements RelationshipRepository {
  final ApiClient _apiClient;

  ApiRelationshipRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<RelationshipModel>> getRelationships({String? category}) async {
    final response = await _apiClient.get(
      ApiEndpoints.relationships.base,
      queryParameters: category != null && category != 'All'
          ? {'category': category}
          : null,
    );

    final List list = response.data as List? ?? [];
    return list
        .map((e) => RelationshipModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RelationshipModel> getRelationship(String id) async {
    final response = await _apiClient.get(ApiEndpoints.relationships.byId(id));

    return RelationshipModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<RelationshipQuestionModel>> getQuestions({
    String? relationshipType,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.relationships.questions,
      queryParameters: relationshipType != null
          ? {'relationshipType': relationshipType}
          : null,
    );

    final List list = response.data as List? ?? [];
    return list
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RelationshipModel> createRelationship({
    required String name,
    required String relationshipType,
    required String category,
    String? photoUrl,
    required List<RelationshipAnswerRequest> answers,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.relationships.base,
      data: {
        'name': name,
        'relationshipType': relationshipType,
        'category': category,
        'photoUrl': photoUrl,
        'answers': answers.map((a) => a.toJson()).toList(),
      },
    );

    return RelationshipModel.fromJson(response.data as Map<String, dynamic>);
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
    final response = await _apiClient.patch(
      ApiEndpoints.relationships.byId(id),
      data: {
        'name': ?name,
        'relationshipType': ?relationshipType,
        'category': ?category,
        'photoUrl': ?photoUrl,
        if (answers != null) 'answers': answers.map((a) => a.toJson()).toList(),
      },
    );

    return RelationshipModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteRelationship(String id) async {
    await _apiClient.delete(ApiEndpoints.relationships.byId(id));
  }
}

// Retain alias for backwards compatibility
typedef LocalRelationshipRepository = ApiRelationshipRepository;
