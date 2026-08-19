import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, errorMessage: null));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void submitLogin() {
    // Phase 1 UI-only stub handler
    emit(state.copyWith(isLoading: true));
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false));
    });
  }
}
