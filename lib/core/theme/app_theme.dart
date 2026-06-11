import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPrimary = Color(0xFF05B875);
  static const Color brandSecondary = Color(0xFF04935D);
  static const Color lightBackground = Color(0xFFF9FAFB); // Light grey/white
  static const Color glassBackground = Color(0xCCFFFFFF); // Mostly opaque white
  static const Color glassBorder = Color(0x33000000); // Subtle dark border

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: brandPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: brandPrimary,
        secondary: brandSecondary,
        surface: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: brandPrimary,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
