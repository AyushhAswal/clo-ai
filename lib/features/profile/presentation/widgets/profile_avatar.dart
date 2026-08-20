import 'package:flutter/material.dart';
import '../../../../core/utils/name_formatter.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double size;

  const ProfileAvatar({super.key, required this.name, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final formattedName = name.toTitleCase();
    final String initial = formattedName.isNotEmpty
        ? formattedName[0].toUpperCase()
        : 'U';

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
