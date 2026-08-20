import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../ai/presentation/screens/ai_loading_screen.dart';
import '../../../ai/presentation/screens/personal_ai_vent_screen.dart';
import '../../../onboarding/presentation/widgets/animated_gradient_orb.dart';

class HomeOrbSection extends StatelessWidget {
  const HomeOrbSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const AILoadingScreen(targetScreen: PersonalAIVentScreen()),
          ),
        );
      },
      child: Column(
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
      ),
    );
  }
}
