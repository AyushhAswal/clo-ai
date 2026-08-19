import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../onboarding/presentation/widgets/animated_gradient_orb.dart';

class VentAiOrb extends StatelessWidget {
  const VentAiOrb({super.key});

  @override
  Widget build(BuildContext context) {
    final double orbSize = 260.r;

    return Center(
      child: SizedBox(
        width: orbSize,
        height: orbSize,
        child: Lottie.asset(
          'assets/animations/Round Gradient.json',
          width: orbSize,
          height: orbSize,
          fit: BoxFit.contain,
          repeat: true,
          errorBuilder: (context, error, stackTrace) {
            return const AnimatedGradientOrb();
          },
        ),
      ),
    );
  }
}
