import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/login_screen.dart';
import 'package:system/features/auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.voidBlack,
          image: DecorationImage(
            image: const NetworkImage(
              'https://i.pinimg.com/originals/2b/2b/2b/2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b.gif',
            ), // Optional: Add a subtle texture or gradient if no image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.8),
              BlendMode.darken,
            ),
            onError:
                (
                  _,
                  __,
                ) {}, // Gracefully handle if image fails (it's just a fallback idea)
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.systemBlue, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.systemBlue.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SYSTEM',
                        style: GoogleFonts.robotoMono(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.systemBlue,
                          shadows: [
                            Shadow(
                              color: AppTheme.systemBlue.withValues(alpha: 0.8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome, Player.',
                        style: GoogleFonts.rajdhani(
                          fontSize: 24,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: AppTheme.systemBlue.withValues(
                        alpha: 0.1,
                      ),
                      side: const BorderSide(color: AppTheme.systemBlue),
                    ),
                    child: Text(
                      'LOG IN',
                      style: GoogleFonts.robotoMono(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.systemBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      side: BorderSide(
                        color: AppTheme.systemBlue.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'BECOME A HUNTER (SIGN UP)',
                      style: GoogleFonts.robotoMono(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
