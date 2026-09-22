import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'thebes_colors.dart';

class ThebesTheme {
  static ThemeData get lightTheme => _buildTheebaTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheebaTheme(Brightness.dark);

  static ThemeData _buildTheebaTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bgColor = isDark ? ThebesColors.darkBackground : ThebesColors.pageBg;
    final surfaceColor = isDark ? ThebesColors.darkSurface : ThebesColors.lightSurface;
    final cardColor = isDark ? ThebesColors.darkCard : Colors.white;
    final borderColor = isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder;
    final textPrimary = isDark ? ThebesColors.darkTextPrimary : ThebesColors.lightTextPrimary;
    final textSecondary = isDark ? ThebesColors.darkTextSecondary : ThebesColors.lightTextSecondary;

    final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final textTheme = GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: ThebesColors.navy,
      scaffoldBackgroundColor: bgColor,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: ThebesColors.orange,
              secondary: ThebesColors.mint,
              surface: surfaceColor,
              error: ThebesColors.error,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: textPrimary,
              outline: borderColor,
            )
          : ColorScheme.light(
              primary: ThebesColors.navy,
              secondary: ThebesColors.orange,
              surface: surfaceColor,
              error: ThebesColors.error,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: textPrimary,
              outline: borderColor,
            ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: ThebesColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        shadowColor: const Color(0x0A000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThebesColors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThebesColors.navy,
          side: const BorderSide(color: ThebesColors.navy, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? ThebesColors.darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ThebesColors.orange, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(
          color: textSecondary,
          fontSize: 13,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: ThebesColors.orangePale,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ThebesColors.orange, size: 24);
          }
          return IconThemeData(color: textSecondary, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ThebesColors.orange,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: ThebesColors.orange,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: ThebesColors.orange,
        unselectedLabelColor: textSecondary,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ThebesColors.sky,
        labelStyle: GoogleFonts.poppins(color: ThebesColors.navy, fontSize: 12, fontWeight: FontWeight.w600),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ThebesColors.navyDark,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ThebesColors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
    );
  }
}
