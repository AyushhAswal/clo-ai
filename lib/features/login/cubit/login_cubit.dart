import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
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

  void submitLogin(AuthCubit authCubit) {
    if (state.email.trim().isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(errorMessage: 'Please enter both email and password'),
      );
      return;
    }
    authCubit.login(email: state.email.trim(), password: state.password);
  }
}
