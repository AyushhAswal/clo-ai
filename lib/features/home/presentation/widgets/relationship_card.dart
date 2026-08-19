import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class AddRelationshipItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddRelationshipItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: AppColors.addRelationshipBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.addRelationshipBorder,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Icon(Icons.add, color: Colors.white, size: 24.r),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Relationship',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ExistingRelationshipItem extends StatelessWidget {
  final String name;
  final String category;
  final VoidCallback onTap;

  const ExistingRelationshipItem({
    super.key,
    required this.name,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            padding: EdgeInsets.all(2.r),
            decoration: const BoxDecoration(
              color: AppColors.relationshipRing,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF181822),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            category,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
