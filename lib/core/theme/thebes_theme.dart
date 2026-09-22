import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThebesTheme {
  static ThemeData get lightTheme => _buildCosmicTheme(Brightness.light);
  static ThemeData get darkTheme => _buildCosmicTheme(Brightness.dark);

  static ThemeData _buildCosmicTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Cosmic palette
    const voidColor = Color(0xFF000814);
    const surfaceColor = Color(0xFF080D1A);
    const cardColor = Color(0xFF0D1220);
    const indigoColor = Color(0xFF5C4FF6);
    const neonGold = Color(0xFFFFD700);
    const neonCyan = Color(0xFF00E5FF);
    const borderColor = Color(0xFF1A2035);

    final textBase = isDark ? Colors.white : Colors.white;
    final textTheme = GoogleFonts.cairoTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.dark().textTheme,
    ).apply(bodyColor: textBase, displayColor: textBase);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: indigoColor,
      scaffoldBackgroundColor: voidColor,
      colorScheme: ColorScheme.dark(
        primary: indigoColor,
        secondary: neonCyan,
        surface: surfaceColor,
        error: const Color(0xFFFF1744),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        outline: borderColor,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        actionsIconTheme: const IconThemeData(color: Colors.white70),
        shadowColor: Colors.black87,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.white.withAlpha(18),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: indigoColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonGold,
          side: BorderSide(color: neonGold.withAlpha(120), width: 1.5),
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
        fillColor: Colors.white.withAlpha(8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: neonCyan, width: 1.5),
        ),
        hintStyle: GoogleFonts.cairo(
          color: Colors.white30,
          fontSize: 13,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withAlpha(15),
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: indigoColor.withAlpha(60),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: neonCyan, size: 24);
          }
          return const IconThemeData(color: Colors.white38, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: neonCyan,
            );
          }
          return GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white38,
          );
        }),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        shadowColor: Colors.black87,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: neonCyan,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: neonCyan,
        unselectedLabelColor: Colors.white38,
        labelStyle: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return neonCyan;
          return Colors.white38;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return neonCyan.withAlpha(80);
          }
          return Colors.white.withAlpha(20);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withAlpha(10),
        labelStyle:
            GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
        side: BorderSide(color: Colors.white.withAlpha(25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardColor,
        contentTextStyle:
            GoogleFonts.cairo(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withAlpha(20)),
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
          side: BorderSide(color: Colors.white.withAlpha(20)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white60,
        tileColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: indigoColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }
}
