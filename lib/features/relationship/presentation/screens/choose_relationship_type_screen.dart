import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/features/relationship/presentation/screens/questionnaire_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseRelationshipTypeScreen extends StatefulWidget {
  final String personName;

  const ChooseRelationshipTypeScreen({super.key, required this.personName});

  @override
  State<ChooseRelationshipTypeScreen> createState() =>
      _ChooseRelationshipTypeScreenState();
}

class _ChooseRelationshipTypeScreenState
    extends State<ChooseRelationshipTypeScreen> {
  String? _selectedType;
  bool _isLoading = false;

  final List<String> _relationshipTypes = const [
    'Romantic',
    'Friend',
    'Professional',
    'Family',
  ];

  void _onTypeSelected(String type) async {
    if (_isLoading) return;

    setState(() {
      _selectedType = type;
      _isLoading = true;
    });

    // Brief delay to match the screenshot selection animation/loading state
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionnaireScreen(
          personName: widget.personName,
          relationshipType: type,
        ),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
              SizedBox(height: 24.h),

              // Title with Italicized Person Name
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    const TextSpan(
                      text: 'Choose Your Relationship\nType with ',
                    ),
                    TextSpan(
                      text: widget.personName,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),

              // Options List
              ..._relationshipTypes.map((type) {
                final bool isSelected = _selectedType == type;

                return GestureDetector(
                  onTap: () => _onTypeSelected(type),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF9B3B83), Color(0xFFE86B5A)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF161622),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected && _isLoading)
                          SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
