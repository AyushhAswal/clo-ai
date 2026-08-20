class AuthEndpoints {
  const AuthEndpoints();

  final String register = '/auth/register';
  final String login = '/auth/login';
  final String me = '/auth/me';
}

class ApiEndpoints {
  static const String authPrefix = '/auth';
  static const AuthEndpoints auth = AuthEndpoints();
}
