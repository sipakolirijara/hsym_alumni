
import 'package:flutter/material.dart';



class AppTheme {

  static const Color primaryPurple = Color(0xFF7351FF);

  static const Color darkBackground = Color(0xFF121212);

  static const Color glassBackground = Color(0x1AFFFFFF);

  static const Color glassBorder = Color(0x33FFFFFF);



  static ThemeData get darkTheme {

    return ThemeData(

      brightness: Brightness.dark,

      primaryColor: primaryPurple,

      scaffoldBackgroundColor: darkBackground,

      colorScheme: const ColorScheme.dark(

        primary: primaryPurple,

        secondary: primaryPurple,

        surface: darkBackground,

      ),

      elevatedButtonTheme: ElevatedButtonThemeData(

        style: ElevatedButton.styleFrom(

          backgroundColor: primaryPurple,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(12),

          ),

        ),

      ),

    );

  }

}

