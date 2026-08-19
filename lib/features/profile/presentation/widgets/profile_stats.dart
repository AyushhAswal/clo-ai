import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final int relationshipsCount;
  final int uploadedChatsCount;
  final int totalMessagesCount;

  const ProfileStats({
    super.key,
    required this.relationshipsCount,
    required this.uploadedChatsCount,
    required this.totalMessagesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Full-Width Relationships Card
        _StatCard(number: '$relationshipsCount', label: 'Relationships'),

        SizedBox(height: 12.h),

        // Bottom Equal-Width Cards Row (Uploaded Chats & Total Messages)
        Row(
          children: [
            Expanded(
              child: _StatCard(
                number: '$uploadedChatsCount',
                label: 'Uploaded Chats',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                number: '$totalMessagesCount',
                label: 'Total Messages',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
