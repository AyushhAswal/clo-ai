import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const CloApp());
}

class CloApp extends StatelessWidget {
  const CloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit()..checkSession(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'CLO AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: child,
          );
        },
        child: const OnboardingScreen(),
      ),
    );
  }
}
