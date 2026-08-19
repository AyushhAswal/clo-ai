import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const CircularBackButton({
    super.key,
    required this.onPressed,
    this.size = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.backButtonBg,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.backButtonIcon,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
