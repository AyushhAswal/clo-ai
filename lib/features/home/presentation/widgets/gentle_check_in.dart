import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/name_formatter.dart';
import '../../../ai/presentation/screens/ai_vent_screen.dart';
import '../../../relationship/presentation/screens/add_relationship_name_screen.dart';
import '../../cubit/my_circle_cubit.dart';
import '../../cubit/my_circle_state.dart';

class GentleCheckInSection extends StatelessWidget {
  const GentleCheckInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCircleCubit, MyCircleState>(
      builder: (context, state) {
        final relationships = state.relationships;
        final hasRelationships = relationships.isNotEmpty;
        final latestPerson = hasRelationships ? relationships.first : null;

        final displayName = latestPerson != null
            ? latestPerson.name.toTitleCase()
            : 'No Relationships Yet';
        final displayCategory = latestPerson != null
            ? (latestPerson.category.isNotEmpty
                  ? latestPerson.category
                  : latestPerson.relationshipType)
            : 'Add a connection';
        final initial = displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : '?';
        final insightText = latestPerson != null
            ? 'Checking in on your relationship with $displayName.'
            : 'Add your first relationship in My Circle to receive personalized insights.';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gentle Check-In',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.04),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row with Avatar, Info, and Magenta Arrow Button
                  Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1C1C28),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              displayCategory,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Magenta Circle Arrow Action Button inside Card
                      GestureDetector(
                        onTap: () {
                          if (latestPerson != null) {
                            // DIRECT navigation to AIVentScreen (skipping AILoadingScreen)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AIVentScreen(
                                  relationshipId: latestPerson.id,
                                  personName: latestPerson.name,
                                  relationshipType: latestPerson.category,
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AddRelationshipNameScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 38.w,
                          height: 38.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFBA42A2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.north_east_rounded,
                              color: Colors.white,
                              size: 18.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Inset Dark Quote Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181822),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.03),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      insightText,
                      style: TextStyle(
                        color: const Color(0xFFD1D5DB),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
