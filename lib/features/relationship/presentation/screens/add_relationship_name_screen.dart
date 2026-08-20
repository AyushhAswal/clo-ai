import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/features/relationship/presentation/screens/choose_relationship_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRelationshipNameScreen extends StatefulWidget {
  const AddRelationshipNameScreen({super.key});

  @override
  State<AddRelationshipNameScreen> createState() =>
      _AddRelationshipNameScreenState();
}

class _AddRelationshipNameScreenState extends State<AddRelationshipNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (!_isNameValid) return;

    final String name = _nameController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChooseRelationshipTypeScreen(personName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar with Back Arrow
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Title
                        Text(
                          'Add Relationship',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Subtitle
                        Text(
                          'This helps us understand and analyze better',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Add Photo Avatar Section
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 86.r,
                                    height: 86.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF222230),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                      size: 48.r,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 24.r,
                                      height: 24.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF333345),
                                        border: Border.all(
                                          color: AppColors.backgroundDark,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                        size: 14.r,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // Name Field Label
                        Text(
                          'Name *',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Name TextField Input
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF191924),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _nameController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: AppColors.primaryAccent,
                            decoration: InputDecoration(
                              hintText: 'Enter Name',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 15.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const Spacer(),

                        SizedBox(height: 16.h),

                        // Bottom Next Button
                        GestureDetector(
                          onTap: _onNextPressed,
                          child: Container(
                            width: double.infinity,
                            height: 52.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              gradient: _isNameValid
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF9B3B83),
                                        Color(0xFFE86B5A),
                                      ],
                                    )
                                  : null,
                              color: _isNameValid
                                  ? null
                                  : const Color(0xFF2A2A38),
                            ),
                            child: Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: _isNameValid
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.4),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
