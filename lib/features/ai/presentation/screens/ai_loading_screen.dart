import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';

/// Dedicated AI Loading Animation Screen shown before entering the AI screen.
/// Automatically transitions to [targetScreen] once the Lottie animation completes.
class AILoadingScreen extends StatefulWidget {
  final Widget targetScreen;

  const AILoadingScreen({super.key, required this.targetScreen});

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTarget();
      }
    });
  }

  void _navigateToTarget() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Lottie.asset(
          'assets/animations/heart_branches_pink_nodes_grey.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration * 0.7;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
