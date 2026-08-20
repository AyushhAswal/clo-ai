import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../chat/presentation/screens/personal_chat_screen.dart';
import '../widgets/vent_ai_orb.dart';
import '../widgets/vent_app_bar.dart';
import '../widgets/vent_controls.dart';

/// Dedicated Personal AIVent Screen matching AIVentScreen's layout, orb, and controls,
/// but focused on the user's personal companion space.
class PersonalAIVentScreen extends StatefulWidget {
  const PersonalAIVentScreen({super.key});

  @override
  State<PersonalAIVentScreen> createState() => _PersonalAIVentScreenState();
}

class _PersonalAIVentScreenState extends State<PersonalAIVentScreen> {
  int _activeControlIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.lg.w,
            right: AppSpacing.lg.w,
            top: AppSpacing.sm.h,
            bottom: 110.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar (Static with Back Navigation)
              VentAppBar(
                onBackPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),

              SizedBox(height: 16.h),

              // Personal Context Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF161622),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Personal Sounding Board',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'CLO AI',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22222E),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Personal Companion',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              // Gradient Personal Vent Info Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B214D),
                      Color(0xFF52275A),
                      Color(0xFF2B143A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF52275A).withValues(alpha: 0.20),
                      blurRadius: 16.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5277),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Safe, judgment-free space',
                            style: TextStyle(
                              color: const Color(0xFFE2D6EE),
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Share Your Personal Space ✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Talk freely about your day, feelings, thoughts, or daily reflections with CLO AI.',
                      style: TextStyle(
                        color: const Color(0xFFD8CEE3),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Center AI Orb (Reused Siri.json Animation)
              const VentAiOrb(),

              SizedBox(height: 28.h),

              // Bottom Action Controls
              VentControls(
                activeIndex: _activeControlIndex,
                onControlTap: (index) {
                  setState(() {
                    _activeControlIndex = index;
                  });
                  if (index == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PersonalChatScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
