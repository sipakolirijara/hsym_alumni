import 'package:flutter/material.dart';

class AppTheme {
  // GPS Alumni Connect Brand Colors (From Documentation Appendix A)
  static const Color brandPrimary = Color(0xFF05B875);
  static const Color brandSecondary = Color(0xFF04935D);
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: brandPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: brandPrimary,
        secondary: brandSecondary,
        surface: darkBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
