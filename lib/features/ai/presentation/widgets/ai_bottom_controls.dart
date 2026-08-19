import 'package:flutter/material.dart';

class AIBottomControls extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onControlTap;

  const AIBottomControls({
    super.key,
    required this.activeIndex,
    required this.onControlTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Chat Button
          _ControlButton(
            icon: Icons.sms_outlined,
            isSelected: activeIndex == 0,
            onTap: () => onControlTap(0),
          ),

          // 2. Text/Input Button (Selected White Button in screenshot)
          _ControlButton(
            icon: Icons.subtitles_outlined,
            isSelected: activeIndex == 1,
            onTap: () => onControlTap(1),
          ),

          // 3. Microphone Muted Button
          _ControlButton(
            icon: Icons.mic_off_outlined,
            isSelected: activeIndex == 2,
            onTap: () => onControlTap(2),
          ),

          // 4. CLO AI Gradient Action Button
          _GradientActionButton(
            isSelected: activeIndex == 3,
            onTap: () => onControlTap(3),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF161620),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.08),
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFF0C0D12) : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _GradientActionButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3E68), Color(0xFFFF9E6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3E68).withValues(alpha: 0.40),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.all_inclusive_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
