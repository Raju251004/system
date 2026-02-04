import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
// import 'package:confetti/confetti.dart'; // Disabled due to Symlink issues
import 'dart:math';

class HabitScreen extends ConsumerStatefulWidget {
  const HabitScreen({super.key});

  @override
  ConsumerState<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends ConsumerState<HabitScreen> {
  // late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    // _confettiController.dispose();
    super.dispose();
  }

  void _onGoodHabit() {
    // _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✨ +XP Clean Living! ✨", style: GoogleFonts.orbitron()),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 500),
      )
    );
  }

  void _onBadHabit() {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text("⚠️ PENALTY! HP Reduced.", style: GoogleFonts.orbitron()), 
         backgroundColor: Colors.red,
         duration: const Duration(milliseconds: 500)
       )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF0F0518),
       body: Stack(
          children: [
             Container(
                decoration: const BoxDecoration(
                   gradient: LinearGradient(
                      colors: [Color(0xFF0F0518), Color(0xFF2E0249)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                   )
                ),
                child: SafeArea(
                   child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text("HABIT PROTOCOL", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24, letterSpacing: 2)),
                            const SizedBox(height: 20),
                            Expanded(
                               child: Row(
                                  children: [
                                     // Good Habits Column
                                     Expanded(child: _buildColumn("GOOD", Colors.greenAccent, ["Early Rise", "Drink Water", "Code 1h", "Workout"], _onGoodHabit)),
                                     const SizedBox(width: 16),
                                     // Bad Habits Column
                                     Expanded(child: _buildColumn("FORBIDDEN", Colors.redAccent, ["Procrastination", "Junk Food", "Skip Workout", "Social Media"], _onBadHabit)),
                                  ],
                               ),
                            ),
                         ],
                      ),
                   ),
                ),
             ),
             // Align(
             //    alignment: Alignment.topCenter,
             //    child: ConfettiWidget(
             //       confettiController: _confettiController,
             //       blastDirection: pi / 2,
             //       maxBlastForce: 5, 
             //       minBlastForce: 2,
             //       emissionFrequency: 0.05,
             //       numberOfParticles: 20, 
             //       gravity: 0.1,
             //    ),
             // ),
          ],
       ),
    );
  }

  Widget _buildColumn(String title, Color color, List<String> habits, VoidCallback onTap) {
     return Column(
        children: [
           Text(title, style: GoogleFonts.rajdhani(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           Expanded(
              child: ListView.builder(
                 itemCount: habits.length,
                 itemBuilder: (context, index) {
                    return Padding(
                       padding: const EdgeInsets.only(bottom: 12.0),
                       child: GestureDetector(
                          onTap: onTap,
                          child: GlassBox(
                             color: color.withOpacity(0.1),
                             borderRadius: BorderRadius.circular(12),
                             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                             child: Center(
                                child: Text(
                                   habits[index],
                                   textAlign: TextAlign.center,
                                   style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                             ),
                          ),
                       ),
                    );
                 },
              ),
           ),
        ],
     );
  }
}
