import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../login/presentation/screens/login_screen.dart';
import '../../cubit/onboarding_cubit.dart';
import '../../cubit/onboarding_state.dart';
import '../widgets/animated_gradient_orb.dart';
import '../widgets/circular_back_button.dart';
import '../widgets/circular_next_button.dart';
import '../widgets/get_started_button.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_top_bar.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingScreenView(),
    );
  }
}

class _OnboardingScreenView extends StatefulWidget {
  const _OnboardingScreenView();

  @override
  State<_OnboardingScreenView> createState() => _OnboardingScreenViewState();
}

class _OnboardingScreenViewState extends State<_OnboardingScreenView> {
  late final PageController _pageController;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingPageData> pages = OnboardingPageData.pages;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: BlocConsumer<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state.isCompleted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
                return;
              }

              if (_pageController.hasClients &&
                  _pageController.page?.round() != state.currentPage) {
                _pageController.animateToPage(
                  state.currentPage,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            builder: (context, state) {
              final bool isFirstPage = state.isFirstPage;
              final bool isSecondPage = state.currentPage == 1;
              final bool isLastPage = state.isLastPage;

              return Column(
                children: [
                  // Top Bar Overlay (Sound Mute Toggle & Skip Button -> jumps to last page)
                  OnboardingTopBar(
                    isMuted: _isMuted,
                    onMuteToggle: _toggleMute,
                    onSkip: () {
                      context.read<OnboardingCubit>().skipToLast();
                    },
                  ),

                  // Upper Orb Region (Screen 2 uses extended gradient orb)
                  Expanded(
                    child: Center(
                      child: AnimatedGradientOrb(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Text Content PageView Region
                  SizedBox(
                    height: isFirstPage
                        ? 250.h
                        : (isSecondPage ? 230.h : 215.h),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().setPage(index);
                      },
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return OnboardingContent(pageData: page);
                      },
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Responsive Bottom Navigation Stack (Back [left] | Page Indicators [center] | Next/Get Started [right])
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                    child: SizedBox(
                      height: 56.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Far Left Slot (Circular Back Button on all pages except Page 1)
                          if (!isFirstPage)
                            Positioned(
                              left: 0,
                              child: CircularBackButton(
                                onPressed: () {
                                  context
                                      .read<OnboardingCubit>()
                                      .previousPage();
                                },
                              ),
                            ),

                          // Center Slot (Centered Page Indicators with zero overlap)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isLastPage ? 100.w : 0,
                            ),
                            child: Center(
                              child: OnboardingPageIndicator(
                                currentPage: state.currentPage,
                                pageCount: pages.length,
                              ),
                            ),
                          ),

                          // Far Right Slot (White Circular Next Button or Get Started Button)
                          Positioned(
                            right: 0,
                            child: !isLastPage
                                ? CircularNextButton(
                                    onPressed: () {
                                      context
                                          .read<OnboardingCubit>()
                                          .nextPage();
                                    },
                                  )
                                : GetStartedButton(
                                    onPressed: () {
                                      context
                                          .read<OnboardingCubit>()
                                          .nextPage();
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
