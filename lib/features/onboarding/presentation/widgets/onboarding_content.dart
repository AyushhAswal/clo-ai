import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingPageData {
  final String titlePrefixBold;
  final String titlePrefixRegular;
  final String titleLine2;
  final String description;
  final bool isCenterAligned;

  const OnboardingPageData({
    required this.titlePrefixBold,
    required this.titlePrefixRegular,
    required this.titleLine2,
    required this.description,
    this.isCenterAligned = false,
  });

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      titlePrefixBold: "",
      titlePrefixRegular: "Hey, I'm ",
      titleLine2: "CLO AI",
      description:
          "I'm your smart, AI-powered guide to self-awareness, emotional clarity, and better relationships.",
      isCenterAligned: true,
    ),
    OnboardingPageData(
      titlePrefixBold: "Decode ",
      titlePrefixRegular: "Your",
      titleLine2: "Relationships",
      description:
          "I track emotional tone, spot patterns, and flagging what feels off.",
      isCenterAligned: false,
    ),
    OnboardingPageData(
      titlePrefixBold: "Navigate ",
      titlePrefixRegular: "With",
      titleLine2: "Clarity",
      description:
          "I help you reflect on messages, intentions, and what's unsaid.",
      isCenterAligned: false,
    ),
    OnboardingPageData(
      titlePrefixBold: "Privacy ",
      titlePrefixRegular: "Comes",
      titleLine2: "First",
      description: "Conversations stay private, encrypted, and never shared.",
      isCenterAligned: false,
    ),
  ];
}

class OnboardingContent extends StatelessWidget {
  final OnboardingPageData pageData;

  const OnboardingContent({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    if (pageData.isCenterAligned) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Geometric White Brand Logo Symbol for Page 1
            Container(
              width: 52.w,
              height: 52.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFF09090C),
                  size: 28.r,
                ),
              ),
            ),

            // Centered Title Text: "Hey, I'm CLO AI"
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 30.sp,
                  color: AppColors.textPrimary,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                children: [
                  const TextSpan(
                    text: "Hey, I'm ",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: pageData.titleLine2,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Centered Subtitle Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                pageData.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    // Left-Aligned Layout for Pages 2, 3, 4
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two-line Title with Exact Word Emphasis Wrapping
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(
                fontSize: 30.sp,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                  text: pageData.titlePrefixBold,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: pageData.titlePrefixRegular,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: pageData.titleLine2,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Left-Aligned Subtitle Description
          Text(
            pageData.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
