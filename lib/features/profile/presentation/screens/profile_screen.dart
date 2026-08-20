import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';
import '../../../login/presentation/screens/login_screen.dart';
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161622),
          title: Text(
            'Are you sure?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await context.read<AuthCubit>().logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
            bottom: 110.h,
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

                  // Profile Header Section with authenticated user name from AuthCubit
                  Builder(
                    builder: (context) {
                      final authState = context.watch<AuthCubit?>()?.state;
                      final name = authState is AuthAuthenticated
                          ? authState.user.name
                          : '';
                      return ProfileHeader(
                        name: name,
                        lastUpdated: state.lastUpdated,
                      );
                    },
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
                    onTap: () => _showLogoutConfirmationDialog(context),
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
