import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String username;

  const HomeHeader({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 26.sp,
              color: AppColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.4,
            ),
            children: [
              const TextSpan(
                text: 'Hello ',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              TextSpan(
                text: '$username,',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Dive deeper into the connections that shape\nyour everyday life.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.35,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
