import 'package:flutter/material.dart';

class ThebesColors {
  // Primary Palette - Thebes Royal Egyptian Navy & Gold
  static const Color primary = Color(0xFF081A32);       // Deepest Egyptian Navy
  static const Color primaryNavy = Color(0xFF081A32);   // Alias for primary
  static const Color primaryLight = Color(0xFF132F54);  // Royal Midnight Blue
  static const Color primaryDark = Color(0xFF040C18);   // Pure Midnight Obsidian
  
  // Secondary & Luxury Accents
  static const Color gold = Color(0xFFD4AF37);          // Egyptian Regal Gold
  static const Color goldLight = Color(0xFFF6DE8F);     // Shimmering Gold
  static const Color goldDark = Color(0xFFA17F19);      // Burnished Antique Gold
  static const Color goldMetallic = Color(0xFFE5C07B);  // Polished Gold Leaf
  
  // Modern Tech Accents
  static const Color cyanAccent = Color(0xFF06B6D4);    // Cyber Cyan / Electric Teal
  static const Color accentBlue = Color(0xFF3B82F6);    // Accent Blue
  static const Color emerald = Color(0xFF10B981);       // Attendance Verified Green
  static const Color purpleAccent = Color(0xFF8B5CF6);  // Academic Honors Purple
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors (Light Luxury Mode)
  static const Color lightBackground = Color(0xFFF4F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0B1727);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Neutral Colors (Dark Luxury Mode)
  static const Color darkBackground = Color(0xFF050B14);
  static const Color darkSurface = Color(0xFF0A1322);
  static const Color darkCard = Color(0xFF0F1E33);
  static const Color darkCardBorder = Color(0xFF1E3352);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Luxury Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF081A32), Color(0xFF132F54), Color(0xFF1D4274)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5C07B), Color(0xFFD4AF37), Color(0xFFC69214)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalCardGradient = LinearGradient(
    colors: [Color(0xFF0B1D38), Color(0xFF122849), Color(0xFF1B3862)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = royalCardGradient;

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldShimmer = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFFF2B2), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient attendanceCardGradient = LinearGradient(
    colors: [Color(0xFF063028), Color(0xFF0A473C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Safe opacity helper compatible with all Flutter versions without deprecation
  static Color opacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }
}
