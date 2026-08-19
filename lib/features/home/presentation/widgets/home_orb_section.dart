import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../onboarding/presentation/widgets/animated_gradient_orb.dart';

class HomeOrbSection extends StatelessWidget {
  const HomeOrbSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Performance-Isolated Animated Gradient Orb
        const AnimatedGradientOrb(),

        SizedBox(height: 16.h),

        Text(
          'Tap to speak',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          'How are you? lets talk about your day',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
