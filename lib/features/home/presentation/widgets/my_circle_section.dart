import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'relationship_card.dart';

class MyCircleSection extends StatelessWidget {
  const MyCircleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Circle',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Dark Relationship Card Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.04),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              AddRelationshipItem(
                onTap: () {
                  // Phase 1 UI action stub
                },
              ),
              SizedBox(width: 20.w),
              ExistingRelationshipItem(
                name: 'Ayush',
                category: 'Professional',
                onTap: () {
                  // Phase 1 UI action stub
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
