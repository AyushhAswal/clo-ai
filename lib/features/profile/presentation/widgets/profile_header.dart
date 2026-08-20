import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/name_formatter.dart';
import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String lastUpdated;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final formattedName = name.toTitleCase();

    return Row(
      children: [
        ProfileAvatar(name: formattedName, size: 72.r),
        SizedBox(width: 18.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedName.isNotEmpty ? formattedName : 'User',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Last updated on $lastUpdated',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
