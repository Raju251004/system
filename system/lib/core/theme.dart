import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color midnightBlack = Color(0xFF000000);
  static const Color deepRoyalBlue = Color(0xFF001d3d);
  static const Color glowingCyan = Color(0xFF00eaff);
  static const Color errorRed = Color(0xFFFF0033);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnightBlack,
      primaryColor: deepRoyalBlue,
      colorScheme: const ColorScheme.dark(
        primary: glowingCyan,
        secondary: deepRoyalBlue,
        surface: deepRoyalBlue,
        error: errorRed,
        onPrimary: midnightBlack,
        onSecondary: glowingCyan,
        onSurface: glowingCyan,
      ),
      fontFamily: GoogleFonts.orbitron().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: glowingCyan,
          letterSpacing: 2.0,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.rajdhani(fontSize: 16, color: Colors.white70),
      ),
      useMaterial3: true,
    );
  }
}
