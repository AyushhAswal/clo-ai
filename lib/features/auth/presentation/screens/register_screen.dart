import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../login/presentation/widgets/custom_text_field.dart';
import '../../../login/presentation/widgets/login_button.dart';
import '../../../login/presentation/widgets/login_header.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _localError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _localError = 'Please fill in all fields';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _localError = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _localError = null;
    });

    context.read<AuthCubit>().register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage =
              _localError ??
              (state is AuthUnauthenticated ? state.errorMessage : null);

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
                        label: 'Full Name',
                        hintText: 'Enter your name',
                        onChanged: (_) {
                          if (_localError != null) {
                            setState(() => _localError = null);
                          }
                        },
                      ).copyWithController(_nameController),

                      SizedBox(height: 16.h),

                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          if (_localError != null) {
                            setState(() => _localError = null);
                          }
                        },
                      ).copyWithController(_emailController),

                      SizedBox(height: 16.h),

                      CustomTextField(
                        label: 'Password',
                        hintText: 'Create a password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onChanged: (_) {
                          if (_localError != null) {
                            setState(() => _localError = null);
                          }
                        },
                      ).copyWithController(_passwordController),

                      SizedBox(height: 28.h),

                      LoginButton(
                        isLoading: isLoading,
                        onPressed: _submitRegister,
                      ),

                      SizedBox(height: 20.h),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                              children: const [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Login',
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

extension _CustomTextFieldExt on CustomTextField {
  Widget copyWithController(TextEditingController controller) {
    return _TextFieldWithController(
      label: label,
      hintText: hintText,
      obscureText: obscureText,
      keyboardType: keyboardType,
      suffixIcon: suffixIcon,
      onSuffixIconPressed: onSuffixIconPressed,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class _TextFieldWithController extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _TextFieldWithController({
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onSuffixIconPressed,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: AppColors.textSecondary,
                        size: 20.r,
                      ),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
