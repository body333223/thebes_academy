import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        // Modern Academic Squircle Crest
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.28),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F1E36), Color(0xFF1E3A66)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: ThebesColors.navy.withAlpha(50),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: ThebesColors.cobalt.withAlpha(40),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background geometric ring
              Container(
                width: size * 0.72,
                height: size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(20),
                    width: 1,
                  ),
                ),
              ),
              // Academic Emblem: Auto Stories + School
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    size: size * 0.42,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: size * 0.28,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: ThebesColors.orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'أكاديمية طـيبة المتكاملة',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: textColor ?? ThebesColors.navy,
              fontSize: (size * 0.24).clamp(16.0, 22.0),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: ThebesColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'THEBES ACADEMY PORTAL',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: ThebesColors.cobalt,
                  fontSize: (size * 0.14).clamp(11.0, 13.0),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: ThebesColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
