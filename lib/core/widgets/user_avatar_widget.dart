import 'package:flutter/material.dart';
import '../theme/thebes_colors.dart';

class UserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? initials;

  const UserAvatarWidget({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ThebesColors.gold, width: 2),
        gradient: ThebesColors.primaryGradient,
      ),
      child: Center(
        child: initials != null && initials!.isNotEmpty
            ? Text(
                initials!,
                style: TextStyle(
                  color: ThebesColors.gold,
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                Icons.person_rounded,
                color: ThebesColors.gold,
                size: size * 0.55,
              ),
      ),
    );
  }
}
