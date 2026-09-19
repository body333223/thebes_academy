import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'thebes_colors.dart';

class ThebesTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.cairoTextTheme(ThemeData.light().textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ThebesColors.primary,
      scaffoldBackgroundColor: ThebesColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: ThebesColors.primary,
        secondary: ThebesColors.gold,
        surface: ThebesColors.lightSurface,
        error: ThebesColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: ThebesColors.lightTextPrimary,
      ),
      textTheme: textTheme.apply(
        bodyColor: ThebesColors.lightTextPrimary,
        displayColor: ThebesColors.lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ThebesColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: ThebesColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ThebesColors.lightCardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThebesColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThebesColors.primary,
          side: const BorderSide(color: ThebesColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.primary, width: 2),
        ),
        hintStyle: GoogleFonts.cairo(
          color: ThebesColors.lightTextMuted,
          fontSize: 13,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: ThebesColors.primaryLight,
      scaffoldBackgroundColor: ThebesColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: ThebesColors.gold,
        secondary: ThebesColors.cyanAccent,
        surface: ThebesColors.darkSurface,
        error: ThebesColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: ThebesColors.darkTextPrimary,
      ),
      textTheme: textTheme.apply(
        bodyColor: ThebesColors.darkTextPrimary,
        displayColor: ThebesColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ThebesColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: ThebesColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ThebesColors.darkCardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThebesColors.gold,
          foregroundColor: Colors.black,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThebesColors.gold,
          side: const BorderSide(color: ThebesColors.gold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThebesColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.darkCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.darkCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThebesColors.gold, width: 2),
        ),
        hintStyle: GoogleFonts.cairo(
          color: ThebesColors.darkTextMuted,
          fontSize: 13,
        ),
      ),
    );
  }
}
