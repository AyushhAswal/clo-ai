import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../ai/presentation/screens/ai_vent_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../widgets/gentle_check_in.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/home_orb_section.dart';
import '../widgets/my_circle_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Content Body according to selectedNavIndex (0 = Home, 1 = AI, 2 = Profile)
          Positioned.fill(
            child: BlocSelector<HomeCubit, HomeState, int>(
              selector: (state) => state.selectedNavIndex,
              builder: (context, selectedIndex) {
                if (selectedIndex == 1) {
                  return const AIVentScreen();
                }

                if (selectedIndex == 2) {
                  return const ProfileScreen();
                }

                return const _HomeBody();
              },
            ),
          ),

          // Centered Floating 3-Tab Bottom Navigation Bar (Home | AI | Profile)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocSelector<HomeCubit, HomeState, int>(
              selector: (state) => state.selectedNavIndex,
              builder: (context, selectedIndex) {
                return HomeBottomNavigation(
                  selectedIndex: selectedIndex,
                  onTabSelected: (index) {
                    context.read<HomeCubit>().selectTab(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: 100, // Extra bottom padding for floating nav bar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with username state selector
            BlocSelector<HomeCubit, HomeState, String>(
              selector: (state) => state.username,
              builder: (context, username) {
                return HomeHeader(username: username);
              },
            ),

            const SizedBox(height: 28),

            // AI Orb Section (Performance Isolated)
            const Center(child: HomeOrbSection()),

            const SizedBox(height: 32),

            // My Circle Section
            const MyCircleSection(),

            const SizedBox(height: 28),

            // Gentle Check-In Section
            const GentleCheckInSection(),
          ],
        ),
      ),
    );
  }
}
