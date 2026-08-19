import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedGradientOrb extends StatefulWidget {
  const AnimatedGradientOrb({super.key});

  @override
  State<AnimatedGradientOrb> createState() => _AnimatedGradientOrbState();
}

class _AnimatedGradientOrbState extends State<AnimatedGradientOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double orbSize = (screenSize.height * 0.25).clamp(180.0, 230.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double animValue = _controller.value;
        final double focalX = -0.10 + 0.08 * math.sin(animValue * math.pi * 2);
        final double focalY = -0.15 + 0.10 * math.cos(animValue * math.pi * 2);
        final double glowPulse = 0.30 + 0.10 * math.sin(animValue * math.pi);

        return SizedBox(
          width: orbSize,
          height: orbSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ambient Soft Glow Matching Screenshot Tone
              Container(
                width: orbSize * 0.90,
                height: orbSize * 0.90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFD95B96,
                      ).withValues(alpha: glowPulse),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFF833B6E).withValues(alpha: 0.35),
                      blurRadius: 80,
                      spreadRadius: 15,
                    ),
                  ],
                ),
              ),

              // Animated Internal Fluid Gradient Orb Body
              Container(
                width: orbSize,
                height: orbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(focalX, focalY),
                    radius: 0.85 + 0.04 * math.sin(animValue * math.pi),
                    colors: const [
                      Color(0xFFFFF5E6), // Soft golden white center
                      Color(0xFFFFA372), // Warm peach/orange halo
                      Color(0xFFD95B96), // Coral pink middle
                      Color(0xFF833B6E), // Deep dusty mauve
                      Color(0xFF4D1B43), // Outer dark purple
                    ],
                    stops: const [0.0, 0.22, 0.48, 0.78, 1.0],
                  ),
                ),
              ),

              // Soft Inner Highlight Refinement
              Positioned(
                top: orbSize * 0.16 + 6 * math.sin(animValue * math.pi),
                left: orbSize * 0.20 + 6 * math.cos(animValue * math.pi),
                child: Container(
                  width: orbSize * 0.38,
                  height: orbSize * 0.38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.65),
                        const Color(0xFFFFF5E6).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Subtle Blur Filter Overlay for Etherial Softness
              ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    width: orbSize,
                    height: orbSize,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
