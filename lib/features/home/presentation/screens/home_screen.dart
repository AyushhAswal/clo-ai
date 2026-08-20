import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../../cubit/my_circle_cubit.dart';
import '../../cubit/my_circle_state.dart';
import '../widgets/gentle_check_in.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/home_orb_section.dart';
import '../widgets/my_circle_section.dart';
import 'my_circle_screen.dart';

class HomeScreen extends StatelessWidget {
  final MyCircleCubit? myCircleCubit;

  const HomeScreen({super.key, this.myCircleCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        if (myCircleCubit != null)
          BlocProvider.value(value: myCircleCubit!)
        else
          BlocProvider(create: (_) => MyCircleCubit()..loadRelationships()),
      ],
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
          // Content Body according to selectedNavIndex (0 = Home, 1 = My Circle, 2 = Profile)
          Positioned.fill(
            child: BlocSelector<HomeCubit, HomeState, int>(
              selector: (state) => state.selectedNavIndex,
              builder: (context, selectedIndex) {
                if (selectedIndex == 1) {
                  return const MyCircleScreen();
                }

                if (selectedIndex == 2) {
                  return const ProfileScreen();
                }

                return const _HomeBody();
              },
            ),
          ),

          // Centered Floating 3-Tab Bottom Navigation Bar (Home | My Circle | Profile)
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
            // Header Section with authenticated user name from AuthCubit
            Builder(
              builder: (context) {
                final authState = context.watch<AuthCubit?>()?.state;
                final name = authState is AuthAuthenticated
                    ? authState.user.name
                    : '';
                return HomeHeader(name: name);
              },
            ),

            const SizedBox(height: 28),

            // AI Orb Section (Performance Isolated)
            const Center(child: HomeOrbSection()),

            const SizedBox(height: 32),

            // My Circle Preview Section connected to shared MyCircleCubit
            BlocBuilder<MyCircleCubit, MyCircleState>(
              builder: (context, state) {
                return MyCircleSection(
                  relationships: state.relationships,
                  onViewAllTap: () {
                    context.read<HomeCubit>().selectTab(1);
                  },
                );
              },
            ),

            const SizedBox(height: 28),

            // Gentle Check-In Section
            const GentleCheckInSection(),
          ],
        ),
      ),
    );
  }
}
