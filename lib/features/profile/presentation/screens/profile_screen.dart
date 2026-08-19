import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileScreenView(),
    );
  }
}

class _ProfileScreenView extends StatelessWidget {
  const _ProfileScreenView();

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
            top: AppSpacing.md.h,
            bottom: 110.h, // Padding for bottom navigation bar
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Profile Header Section
                  ProfileHeader(
                    username: state.username,
                    lastUpdated: state.lastUpdated,
                  ),

                  SizedBox(height: 28.h),

                  // Statistics Section
                  ProfileStats(
                    relationshipsCount: state.relationshipsCount,
                    uploadedChatsCount: state.uploadedChatsCount,
                    totalMessagesCount: state.totalMessagesCount,
                  ),

                  SizedBox(height: 24.h),

                  // Profile Actions Section
                  ProfileActionTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileActionTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings & Privacy',
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileActionTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () {},
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
