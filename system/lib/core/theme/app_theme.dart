import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color voidBlack = Color(0xFF050510);
  static const Color systemBlue = Color(0xFF00AEEF);
  static const Color manaBlue = Color(0xFF2E86DE);
  static const Color alertRed = Color(0xFFFF3333);
  static const Color gold = Color(0xFFFFD700);
  static const Color terminalGreen = Color(0xFF00FF00);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidBlack,
      primaryColor: systemBlue,
      colorScheme: const ColorScheme.dark(
        primary: systemBlue,
        secondary: manaBlue,
        error: alertRed,
        surface: voidBlack,
        onSurface: systemBlue,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.robotoMono(
          color: systemBlue,
          fontWeight: FontWeight.bold,
          fontSize: 32,
          shadows: [
            Shadow(color: systemBlue.withValues(alpha: 0.5), blurRadius: 10),
          ],
        ),
        displayMedium: GoogleFonts.robotoMono(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.rajdhani(color: Colors.white, fontSize: 18),
        bodyMedium: GoogleFonts.rajdhani(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: systemBlue.withValues(alpha: 0.1),
          foregroundColor: systemBlue,
          side: const BorderSide(color: systemBlue),
          textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: systemBlue.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: systemBlue.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: systemBlue.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: systemBlue),
          borderRadius: BorderRadius.circular(4),
        ),
        labelStyle: GoogleFonts.robotoMono(
          color: systemBlue.withValues(alpha: 0.7),
        ),
        hintStyle: GoogleFonts.rajdhani(color: Colors.white24),
      ),
    );
  }
}
