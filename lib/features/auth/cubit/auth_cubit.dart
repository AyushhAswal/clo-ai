import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_exception.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(const AuthInitial());

  AuthRepository get repository => _repository;

  Future<void> checkSession() async {
    emit(const AuthLoading());
    try {
      final user = await _repository.restoreSession();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on ApiException catch (e) {
      emit(AuthUnauthenticated(e.message));
    } catch (e) {
      emit(const AuthUnauthenticated('Login failed. Please try again.'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on ApiException catch (e) {
      emit(AuthUnauthenticated(e.message));
    } catch (e) {
      emit(const AuthUnauthenticated('Registration failed. Please try again.'));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }
}
