import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String username;
  final double size;

  const ProfileAvatar({super.key, required this.username, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final String initial = username.isNotEmpty
        ? username[0].toUpperCase()
        : 'A';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF9C43A4),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
