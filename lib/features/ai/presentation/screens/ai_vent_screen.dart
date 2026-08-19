import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../cubit/ai_cubit.dart';
import '../../cubit/ai_state.dart';
import '../widgets/relationship_header.dart';
import '../widgets/vent_ai_orb.dart';
import '../widgets/vent_app_bar.dart';
import '../widgets/vent_controls.dart';
import '../widgets/vent_info_card.dart';

class AIVentScreen extends StatelessWidget {
  const AIVentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AICubit(),
      child: const _AIVentScreenView(),
    );
  }
}

class _AIVentScreenView extends StatelessWidget {
  const _AIVentScreenView();

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
            top: AppSpacing.sm.h,
            bottom: 110.h, // Bottom padding for floating navigation capsule
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar (Static, zero state rebuilds)
              const VentAppBar(),

              SizedBox(height: 16.h),

              // Relationship Header Card
              BlocSelector<AICubit, AIState, ({String name, String category})>(
                selector: (state) =>
                    (name: state.relationshipName, category: state.category),
                builder: (context, contextData) {
                  return RelationshipHeader(
                    name: contextData.name,
                    category: contextData.category,
                  );
                },
              ),

              SizedBox(height: 14.h),

              // Gradient Vent Info Card (Static)
              const VentInfoCard(),

              SizedBox(height: 24.h),

              // Center AI Orb (Performance Isolated Siri.json Animation)
              const VentAiOrb(),

              SizedBox(height: 28.h),

              // Bottom Vent Action Controls (Scoped rebuilds)
              BlocSelector<AICubit, AIState, int>(
                selector: (state) => state.activeControlIndex,
                builder: (context, activeIndex) {
                  return VentControls(
                    activeIndex: activeIndex,
                    onControlTap: (index) {
                      context.read<AICubit>().selectControl(index);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
