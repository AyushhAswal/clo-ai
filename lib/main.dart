import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/features/home/presentation/screens/home_screen.dart';
import 'package:clo_ai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CloApp());
}

class CloApp extends StatelessWidget {
  final AuthCubit? authCubit;

  const CloApp({super.key, this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (authCubit ?? AuthCubit())..checkSession(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'CLO AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const RootAuthWrapper(),
          );
        },
      ),
    );
  }
}

class RootAuthWrapper extends StatelessWidget {
  const RootAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
