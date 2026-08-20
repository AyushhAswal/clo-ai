import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';
import '../../../auth/domain/models/user_auth_model.dart';
import '../../../auth/presentation/screens/register_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/login_button.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginScreenView(),
    );
  }
}

class _LoginScreenView extends StatelessWidget {
  const _LoginScreenView();

  void _navigateToHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is AuthAuthenticated) {
            _navigateToHome(context);
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isAuthLoading = authState is AuthLoading;
            final authErrorMessage = authState is AuthUnauthenticated
                ? authState.errorMessage
                : null;

            return BlocBuilder<LoginCubit, LoginState>(
              builder: (context, loginState) {
                final isLoading = isAuthLoading || loginState.isLoading;
                final errorMessage =
                    loginState.errorMessage ?? authErrorMessage;

                return Column(
                  children: [
                    const LoginHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg.w,
                          vertical: AppSpacing.md.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),

                            if (errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],

                            CustomTextField(
                              label: 'Email',
                              hintText: 'Enter the Email',
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) =>
                                  context.read<LoginCubit>().emailChanged(val),
                            ),

                            SizedBox(height: 20.h),

                            CustomTextField(
                              label: 'Password',
                              hintText: 'Enter your Password',
                              obscureText: !loginState.isPasswordVisible,
                              suffixIcon: loginState.isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              onSuffixIconPressed: () {
                                context
                                    .read<LoginCubit>()
                                    .togglePasswordVisibility();
                              },
                              onChanged: (val) => context
                                  .read<LoginCubit>()
                                  .passwordChanged(val),
                            ),

                            SizedBox(height: 12.h),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            LoginButton(
                              isLoading: isLoading,
                              onPressed: () {
                                final authCubit = context.read<AuthCubit>();
                                context.read<LoginCubit>().submitLogin(
                                  authCubit,
                                );
                              },
                            ),

                            SizedBox(height: 20.h),

                            Center(
                              child: GestureDetector(
                                onTap: () => _navigateToRegister(context),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                    children: const [
                                      TextSpan(text: "Don't have an account? "),
                                      TextSpan(
                                        text: 'Signup',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 28.h),

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: Text(
                                    'Or',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.h,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 28.h),

                            GoogleSignInButton(
                              onPressed: () {
                                final authCubit = context.read<AuthCubit>();
                                if (authCubit.state is! AuthAuthenticated) {
                                  authCubit.setSessionUser(
                                    const UserAuthModel(
                                      id: 'google-user',
                                      name: 'ayush aswal',
                                      email: 'google@example.com',
                                    ),
                                  );
                                } else {
                                  _navigateToHome(context);
                                }
                              },
                            ),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
