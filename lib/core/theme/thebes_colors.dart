import 'package:flutter/material.dart';

class ThebesColors {
  // Primary Palette - Thebes Royal Navy & Gold
  static const Color primary = Color(0xFF0C2340);       // Dark Navy Blue
  static const Color primaryLight = Color(0xFF1D3557);  // Classic Blue
  static const Color primaryDark = Color(0xFF061426);   // Deep Obsidian Navy
  
  // Secondary & Accents
  static const Color gold = Color(0xFFD4AF37);          // Academic Gold
  static const Color goldLight = Color(0xFFF1D067);     // Bright Gold
  static const Color goldDark = Color(0xFFAA820A);      // Deep Gold
  static const Color cyanAccent = Color(0xFF00A896);    // Modern Teal / Cyan
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors (Light Mode)
  static const Color lightBackground = Color(0xFFF4F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Neutral Colors (Dark Mode)
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF121927);
  static const Color darkCard = Color(0xFF1B2436);
  static const Color darkCardBorder = Color(0xFF2E3A52);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0C2340), Color(0xFF1D3557)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF5D77F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF121E31), Color(0xFF1E3252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Safe opacity helper compatible with all Flutter versions without deprecation
  static Color opacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }
}
