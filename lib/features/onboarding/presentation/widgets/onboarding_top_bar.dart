import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback onMuteToggle;
  final VoidCallback onSkip;
  final bool isMuted;

  const OnboardingTopBar({
    super.key,
    required this.onMuteToggle,
    required this.onSkip,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Speaker / Mute Icon Button (Top-left)
          GestureDetector(
            onTap: onMuteToggle,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.topBarIconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Skip Button (Top-right)
          GestureDetector(
            onTap: onSkip,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.skipButtonBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: const Text('Skip', style: AppTextStyles.topBarSkip),
            ),
          ),
        ],
      ),
    );
  }
}
