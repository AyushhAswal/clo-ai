import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/message_model.dart';
import '../../domain/models/personal_chat_model.dart';

class PersonalChatRepository {
  final ApiClient _apiClient;

  PersonalChatRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Retrieves or creates the single persistent PersonalChat session for the authenticated user.
  Future<PersonalChatModel> getOrCreatePersonalChat() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.personalChats.base,
    );
    return PersonalChatModel.fromJson(response.data!);
  }

  /// Retrieves messages for the authenticated user's persistent PersonalChat.
  Future<List<MessageModel>> getMessages() async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.personalChats.messages,
    );

    return (response.data ?? [])
        .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Sends a user message in the PersonalChat session and receives the AI assistant response.
  Future<MessageModel> sendMessage(String content) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.personalChats.messages,
      data: {'content': content},
    );

    return MessageModel.fromJson(response.data!);
  }

  /// Clears personal conversation history.
  Future<void> deletePersonalChat() async {
    await _apiClient.delete<Map<String, dynamic>>(
      ApiEndpoints.personalChats.base,
    );
  }
}
