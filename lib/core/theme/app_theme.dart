import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPrimary = Color(0xFF05B875);
  static const Color brandSecondary = Color(0xFF04935D);
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color glassBackground = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x33000000);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: brandPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(primary: brandPrimary, secondary: brandSecondary, surface: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: brandPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
