import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../cubit/ai_cubit.dart';
import '../../cubit/ai_state.dart';
import '../widgets/ai_bottom_controls.dart';
import '../widgets/ai_header.dart';
import '../widgets/ai_orb_section.dart';
import '../widgets/relationship_context_card.dart';
import '../widgets/understanding_card.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AICubit(), child: const _AIScreenView());
  }
}

class _AIScreenView extends StatelessWidget {
  const _AIScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.sm,
            bottom: 110, // Bottom padding for floating navigation capsule
          ),
          child: BlocBuilder<AICubit, AIState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Bar
                  const AIHeader(),

                  const SizedBox(height: 16),

                  // Relationship Context Card
                  RelationshipContextCard(
                    name: state.relationshipName,
                    category: state.category,
                  ),

                  const SizedBox(height: 14),

                  // Understanding Gradient Card
                  const UnderstandingCard(),

                  const SizedBox(height: 24),

                  // Center Isolated Animated Gradient Orb
                  const AIOrbSection(),

                  const SizedBox(height: 28),

                  // Bottom AI Circular Control Buttons
                  AIBottomControls(
                    activeIndex: state.activeControlIndex,
                    onControlTap: (index) {
                      context.read<AICubit>().selectControl(index);
                    },
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
