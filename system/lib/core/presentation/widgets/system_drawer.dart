import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/home/presentation/welcome_screen.dart';
import 'dart:ui';

class SystemDrawer extends ConsumerWidget {
  const SystemDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Colors
    const Color bgDark = Color(0xFF0F0518);
    const Color neonBlue = Color(0xFF00D2D3);
    const Color accentPurple = Color(0xFF9D4EDD);

    return Drawer(
      backgroundColor: Colors.transparent, // For glassmorphism
      child: Container(
        decoration: BoxDecoration(
          color: bgDark.withOpacity(0.85),
          border: const Border(
            right: BorderSide(color: neonBlue, width: 1.5),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Header
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      accentPurple.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: neonBlue, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: neonBlue.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'SYSTEM MENU',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Items
              _buildMenuItem(
                icon: Icons.person,
                title: 'HUNTER PROFILE',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Profile
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                title: 'SETTINGS',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Settings
                },
              ),
              _buildMenuItem(
                icon: Icons.notifications,
                title: 'NOTIFICATIONS',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Notifications
                },
              ),
              const Spacer(),

              // Logout
              _buildMenuItem(
                icon: Icons.logout,
                title: 'LOG OUT',
                color: Colors.redAccent,
                onTap: () async {
                  await ref
                      .read(authStateProvider.notifier)
                      .setUnauthenticated();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: GoogleFonts.rajdhani(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
