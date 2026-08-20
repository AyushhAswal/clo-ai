import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/core/network/api_exception.dart';
import 'package:clo_ai/features/home/data/repositories/relationship_repository.dart';
import 'package:clo_ai/features/relationship/domain/models/question_model.dart';
import 'package:clo_ai/features/relationship/domain/models/relationship_answer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionnaireScreen extends StatefulWidget {
  final String personName;
  final String relationshipType;
  final RelationshipRepository? repository;

  const QuestionnaireScreen({
    super.key,
    required this.personName,
    required this.relationshipType,
    this.repository,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  List<QuestionModel> _questions = [];
  bool _isLoadingQuestions = true;
  String? _questionsError;
  bool _isSubmitting = false;

  int _currentStep = 0;
  final Map<int, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoadingQuestions = true;
      _questionsError = null;
    });

    try {
      final repository = widget.repository ?? ApiRelationshipRepository();
      final questions = await repository.getQuestions(
        relationshipType: widget.relationshipType,
      );
      setState(() {
        _questions = questions;
        _isLoadingQuestions = false;
      });
    } catch (e) {
      setState(() {
        _questionsError = e.toString();
        _isLoadingQuestions = false;
      });
    }
  }

  void _onOptionSelected(String option) {
    setState(() {
      _selectedAnswers[_currentStep] = option;
    });
  }

  void _onNextPressed() {
    if (!_selectedAnswers.containsKey(_currentStep)) return;

    if (_currentStep < _questions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeQuestionnaire();
    }
  }

  Future<void> _completeQuestionnaire() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    String category = widget.relationshipType;
    if (category.toLowerCase().contains('friend')) {
      category = 'Friends';
    }

    final String relType =
        widget.relationshipType.toLowerCase().contains('friend')
        ? 'Friendship'
        : widget.relationshipType;

    final List<RelationshipAnswerRequest> answerRequests = [];
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final String? selected = _selectedAnswers[i];
      if (selected != null) {
        answerRequests.add(
          RelationshipAnswerRequest(
            questionId: q.id,
            questionText: q.questionText,
            answer: selected,
          ),
        );
      }
    }

    try {
      final repository = widget.repository ?? ApiRelationshipRepository();
      await repository.createRelationship(
        name: widget.personName,
        relationshipType: relType,
        category: category,
        photoUrl: null,
        answers: answerRequests,
      );

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create relationship: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingQuestions) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
      );
    }

    if (_questionsError != null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white70,
                  size: 48.r,
                ),
                SizedBox(height: 16.h),
                Text(
                  _questionsError ?? 'No questions available',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _fetchQuestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentStep];
    final String? currentAnswer = _selectedAnswers[_currentStep];
    final bool hasSelection = currentAnswer != null;
    final bool isLastStep = _currentStep == _questions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Back button, Avatar + Name, Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep--;
                        });
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
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

                  // Person Badge
                  Row(
                    children: [
                      Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF333345),
                        ),
                        child: Center(
                          child: Text(
                            widget.personName.isNotEmpty
                                ? widget.personName[0].toUpperCase()
                                : 'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.personName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '• ${widget.relationshipType}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  // Progress Segment Bar
                  Row(
                    children: List.generate(_questions.length, (index) {
                      final bool isDone = index <= _currentStep;
                      return Container(
                        margin: EdgeInsets.only(left: 4.w),
                        width: 14.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: isDone
                              ? const Color(0xFFE86B5A)
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // Question Title
              Text(
                currentQuestion.questionText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 28.h),

              // Options List
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final option = currentQuestion.options[index];
                    final bool isSelected = currentAnswer == option;

                    return GestureDetector(
                      onTap: () => _onOptionSelected(option),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: isSelected
                              ? const Color(0xFF2A1C2E)
                              : const Color(0xFF161622),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE86B5A)
                                : Colors.white.withValues(alpha: 0.08),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.85),
                                  fontSize: 15.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(width: 8.w),
                              Container(
                                width: 22.r,
                                height: 22.r,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF9B3B83),
                                      Color(0xFFE86B5A),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14.r,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Action Controls
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: const Color(0xFF1A1A26),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_none_rounded,
                            color: AppColors.textSecondary,
                            size: 18.r,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Tap to add yours',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Next / Complete Button
                  GestureDetector(
                    onTap: _isSubmitting ? null : _onNextPressed,
                    child: Container(
                      width: 100.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        gradient: hasSelection && !_isSubmitting
                            ? const LinearGradient(
                                colors: [Color(0xFF9B3B83), Color(0xFFE86B5A)],
                              )
                            : null,
                        color: hasSelection && !_isSubmitting
                            ? null
                            : const Color(0xFF2A2A38),
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                isLastStep ? 'Complete' : 'Next',
                                style: TextStyle(
                                  color: hasSelection
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.4),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
