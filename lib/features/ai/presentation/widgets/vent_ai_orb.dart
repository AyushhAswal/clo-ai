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
        child: Stack(
          alignment: Alignment.center,
          children: [

            Container(
              width: orbSize * 0.75,
              height: orbSize * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD85A91).withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 70.r,
                    spreadRadius: 20.r,
                  ),
                  BoxShadow(
                    color: const Color(0xFF8A3D6D).withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 120.r,
                    spreadRadius: 35.r,
                  ),
                ],
              ),
            ),

            // Orb animation
            ClipOval(
              child: ColorFiltered( colorFilter: const ColorFilter.mode(
                Color(0xFFE05291),
                BlendMode.modulate,
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}