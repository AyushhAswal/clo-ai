import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../ai/presentation/screens/ai_vent_screen.dart';
import '../../../relationship/presentation/screens/add_relationship_name_screen.dart';
import '../../domain/models/relationship_model.dart';
import 'relationship_card.dart';

class MyCircleSection extends StatelessWidget {
  final List<RelationshipModel> relationships;
  final VoidCallback? onViewAllTap;

  const MyCircleSection({
    super.key,
    this.onViewAllTap,
    this.relationships = const [],
  });

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
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AddRelationshipItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddRelationshipNameScreen(),
                      ),
                    );
                  },
                ),
                ...relationships.map(
                  (person) => Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: ExistingRelationshipItem(
                      name: person.name,
                      category: person.relationshipType,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AIVentScreen(
                              personName: person.name,
                              relationshipType: person.category,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
