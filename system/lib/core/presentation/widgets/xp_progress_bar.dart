import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class XpProgressBar extends ConsumerWidget {
  final int currentXp;
  final int requiredXp;
  final int level;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.requiredXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double progress = (currentXp / requiredXp).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      height: 32, // Height for the bar + text
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0518).withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Level Text
          Text(
            'LVL $level',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          // Bar
          Expanded(
            child: Stack(
              children: [
                // Background Track
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Fill Gradient
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * progress,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2E86DE), // Blue
                            Color(0xFF00D2D3), // Cyan neon
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D2D3).withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // XP Text
          Text(
            '${(progress * 100).toStringAsFixed(1)}%',
            style: GoogleFonts.rajdhani(
              color: const Color(0xFF00D2D3),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
