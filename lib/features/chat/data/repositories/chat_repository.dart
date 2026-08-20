import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/chat_model.dart';
import '../../domain/models/message_model.dart';

abstract class ChatRepository {
  Future<ChatModel> getChat(String relationshipId);

  Future<List<MessageModel>> getMessages(String relationshipId);

  Future<MessageModel> sendMessage(String relationshipId, String content);

  Future<void> deleteChat(String relationshipId);
}

class ApiChatRepository implements ChatRepository {
  final ApiClient _apiClient;

  ApiChatRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<ChatModel> getChat(String relationshipId) async {
    final response = await _apiClient.get(
      ApiEndpoints.chats.byRelationshipId(relationshipId),
    );

    return ChatModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<MessageModel>> getMessages(String relationshipId) async {
    final response = await _apiClient.get(
      ApiEndpoints.chats.messages(relationshipId),
    );

    final List list = response.data as List? ?? [];
    return list
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MessageModel> sendMessage(
    String relationshipId,
    String content,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.chats.messages(relationshipId),
      data: {'content': content},
    );

    return MessageModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteChat(String relationshipId) async {
    await _apiClient.delete(
      ApiEndpoints.chats.byRelationshipId(relationshipId),
    );
  }
}
