import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VentInfoCard extends StatelessWidget {
  const VentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B214D), Color(0xFF52275A), Color(0xFF2B143A)],
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
          // Bullet Status Line
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
                  'Take your time—no wrong answers',
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

          // Heading
          Text(
            'Unlock Deeper Understanding 🔥',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: 8.h),

          // Description Text
          Text(
            "You've taken the first step. Continue the\nconversation to gain clearer perspectives.",
            style: TextStyle(
              color: const Color(0xFFD8CEE3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
