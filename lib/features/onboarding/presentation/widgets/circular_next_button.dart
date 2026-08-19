import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CircularNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const CircularNextButton({
    super.key,
    required this.onPressed,
    this.size = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.circularButtonBg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.circularButtonIcon,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
