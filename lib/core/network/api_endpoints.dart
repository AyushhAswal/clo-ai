class AuthEndpoints {
  const AuthEndpoints();

  final String register = '/auth/register';
  final String login = '/auth/login';
  final String me = '/auth/me';
}

class RelationshipEndpoints {
  const RelationshipEndpoints();

  final String base = '/relationships';
  final String questions = '/relationships/questions';

  String byId(String id) => '/relationships/$id';
}

class ChatEndpoints {
  const ChatEndpoints();

  final String base = '/chats';
  String byRelationshipId(String relationshipId) => '/chats/$relationshipId';
  String messages(String relationshipId) => '/chats/$relationshipId/messages';
}

class PersonalChatEndpoints {
  const PersonalChatEndpoints();

  final String base = '/personal-chats';
  final String messages = '/personal-chats/messages';
}

class ApiEndpoints {
  static const String authPrefix = '/auth';
  static const String relationshipsPrefix = '/relationships';
  static const String chatsPrefix = '/chats';
  static const String personalChatsPrefix = '/personal-chats';
  static const AuthEndpoints auth = AuthEndpoints();
  static const RelationshipEndpoints relationships = RelationshipEndpoints();
  static const ChatEndpoints chats = ChatEndpoints();
  static const PersonalChatEndpoints personalChats = PersonalChatEndpoints();
}
