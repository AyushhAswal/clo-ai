import 'package:flutter/material.dart';
import '../../../onboarding/presentation/widgets/animated_gradient_orb.dart';

class AIOrbSection extends StatelessWidget {
  const AIOrbSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AnimatedGradientOrb());
  }
}
