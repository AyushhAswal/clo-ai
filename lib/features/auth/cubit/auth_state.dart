import '../domain/models/user_auth_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserAuthModel user;

  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  final String? errorMessage;

  const AuthUnauthenticated([this.errorMessage]);
}
