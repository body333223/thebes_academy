import 'package:flutter/material.dart';
import '../theme/thebes_colors.dart';

class ThebesLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const ThebesLogoWidget({
    super.key,
    this.size = 80,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: ThebesColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: ThebesColors.opacity(ThebesColors.primaryDark, 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: ThebesColors.opacity(ThebesColors.gold, 0.25),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
            border: Border.all(
              color: ThebesColors.gold,
              width: size * 0.035,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.school_rounded,
                size: size * 0.48,
                color: ThebesColors.gold,
              ),
              Positioned(
                bottom: size * 0.12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size * 0.08,
                    vertical: size * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: ThebesColors.gold,
                    borderRadius: BorderRadius.circular(size * 0.1),
                  ),
                  child: Text(
                    'THEBES',
                    style: TextStyle(
                      color: ThebesColors.primaryDark,
                      fontSize: size * 0.12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'أكاديمية طـيبة المتكاملة للعلوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? ThebesColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'THEBES ACADEMY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThebesColors.gold,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ],
    );
  }
}
