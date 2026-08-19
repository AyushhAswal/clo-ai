import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class VentAppBar extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;

  const VentAppBar({super.key, this.onBackPressed, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Circular Dark Back Button
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF161620),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 26.r,
                ),
              ),
            ),
          ),

          // Center Title with Downward Chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vent to CLO',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 22.r,
              ),
            ],
          ),

          // Right Three-Dot Options Menu Icon
          GestureDetector(
            onTap: onMenuPressed,
            child: SizedBox(
              width: 44.w,
              height: 44.h,
              child: Center(
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 22.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
