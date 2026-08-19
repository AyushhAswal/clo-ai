import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AIHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;

  const AIHeader({super.key, this.onBackPressed, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Circular Dark Back Button
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF161620),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.0,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // Center Title with Downward Chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Vent to CLO',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),

          // Right Three-Dot Options Menu Icon
          GestureDetector(
            onTap: onMenuPressed,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
