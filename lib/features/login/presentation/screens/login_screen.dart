import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Column(
            children: [
              // Ambient Purple Gradient Header
              const LoginHeader(),

              // Scrollable Login Form Area
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

                      // Email Field
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter the Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) =>
                            context.read<LoginCubit>().emailChanged(val),
                      ),

                      SizedBox(height: 20.h),

                      // Password Field
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your Password',
                        obscureText: !state.isPasswordVisible,
                        suffixIcon: state.isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          context.read<LoginCubit>().togglePasswordVisibility();
                        },
                        onChanged: (val) =>
                            context.read<LoginCubit>().passwordChanged(val),
                      ),

                      SizedBox(height: 12.h),

                      // Forgot Password Link (Right-aligned)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Phase 1 UI stub
                          },
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

                      // Primary Login Action Button
                      LoginButton(
                        isLoading: state.isLoading,
                        onPressed: () => _navigateToHome(context),
                      ),

                      SizedBox(height: 20.h),

                      // Don't have an account? Signup text link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Phase 1 UI stub
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                              children: const [
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Signup",
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

                      // "Or" Divider Line
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.h,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
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

                      // Google Sign-In Button
                      GoogleSignInButton(
                        onPressed: () => _navigateToHome(context),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
