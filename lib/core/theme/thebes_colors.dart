import 'package:flutter/material.dart';

/// Theeba Academy Portal Design System Colors
/// Single Source of Truth as specified in DESIGN_SPEC.md
class ThebesColors {
  // Primary Palette - Deep Academic Navy & Royal Cobalt
  static const Color navy = Color(0xFF0F1E36);
  static const Color primary = Color(0xFF0F1E36);
  static const Color primaryNavy = Color(0xFF0F1E36);
  static const Color navyDark = Color(0xFF08101E);
  static const Color primaryDark = Color(0xFF08101E);
  static const Color navyLight = Color(0xFF1E3A66);
  static const Color primaryLight = Color(0xFF1E3A66);

  // Royal Cobalt - Primary Accent for Modern Academic EdTech
  static const Color cobalt = Color(0xFF2563EB);
  static const Color cobaltLight = Color(0xFF3B82F6);
  static const Color cobaltPale = Color(0xFFEFF6FF);

  // Accent Palette - Vibrant Amber / Coral for Badges & CTAs
  static const Color orange = Color(0xFFFF6B2B);
  static const Color accent = Color(0xFFFF6B2B);
  static const Color orangeLight = Color(0xFFFF8C55);
  static const Color orangePale = Color(0xFFFFF0EA);

  // Supporting & Category Tones
  static const Color sky = Color(0xFFEEF4FF);
  static const Color mint = Color(0xFF10B981);
  static const Color slate = Color(0xFF64748B);
  static const Color slateLight = Color(0xFF94A3B8);
  static const Color slateDark = Color(0xFF1E293B);

  // Legacy / Golden Accents for backward compatibility
  static const Color gold = Color(0xFFFF6B2B); // Mapped to primary vibrant accent
  static const Color goldLight = Color(0xFFFF8C55);
  static const Color goldDark = Color(0xFFE05315);
  static const Color goldMetallic = Color(0xFFFF8C55);
  static const Color cyanAccent = Color(0xFF2563EB);
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color emerald = Color(0xFF10B981);
  static const Color purpleAccent = Color(0xFF7C3AED);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF2563EB);

  // Surface & Background Colors
  static const Color pageBg = Color(0xFFF8FAFC);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Mode Surfaces
  static const Color darkBackground = Color(0xFF0A1128);
  static const Color darkSurface = Color(0xFF0F1A3D);
  static const Color darkCard = Color(0xFF15224F);
  static const Color darkCardBorder = Color(0xFF223670);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryHeaderGradient = LinearGradient(
    colors: [Color(0xFF0F1E36), Color(0xFF1E3A66)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = primaryHeaderGradient;

  static const LinearGradient cobaltGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeCtaGradient = LinearGradient(
    colors: [Color(0xFFFF6B2B), Color(0xFFFF8C55)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldGradient = cobaltGradient;

  static const LinearGradient logoGradient = LinearGradient(
    colors: [Color(0xFF0F1E36), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF08101E), Color(0xFF0F1E36), Color(0xFF1E3A66)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient royalCardGradient = LinearGradient(
    colors: [Color(0xFF0F1E36), Color(0xFF1E3A66)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = royalCardGradient;

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldShimmer = orangeCtaGradient;

  static const LinearGradient attendanceCardGradient = LinearGradient(
    colors: [Color(0xFF0A3D31), Color(0xFF00C9A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subject / Category Color Map
  static const Color catCsBg = Color(0xFFE8EEFF);
  static const Color catCsText = Color(0xFF1A2B5F);

  static const Color catBusinessBg = Color(0xFFFFF0EA);
  static const Color catBusinessText = Color(0xFFFF6B2B);

  static const Color catHealthBg = Color(0xFFE8FFF6);
  static const Color catHealthText = Color(0xFF00C9A7);

  static const Color catMathBg = Color(0xFFF3E8FF);
  static const Color catMathText = Color(0xFF7C3AED);

  static const Color catLanguagesBg = Color(0xFFFEF3C7);
  static const Color catLanguagesText = Color(0xFFF59E0B);

  static const Color catAlertBg = Color(0xFFFFE4E4);
  static const Color catAlertText = Color(0xFFEF4444);

  /// Safe opacity helper
  static Color opacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }
}
