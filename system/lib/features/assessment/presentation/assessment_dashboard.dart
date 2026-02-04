import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/assessment/presentation/assessment_controller.dart';
import 'package:system/features/assessment/presentation/workout_input_screen.dart';

class AssessmentDashboard extends ConsumerWidget {
  const AssessmentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentControllerProvider);
    
    // Aesthetic Colors
    const Color _bgDark = Color(0xFF0F0518);
    const Color _neonBlue = Color(0xFF00D2D3);

    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        title: Text('FITNESS ANALYSIS', style: GoogleFonts.orbitron(letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator(color: _neonBlue)),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (stats) {
          final level = stats['level'] ?? 'Unranked';
          final average = stats['average'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Card
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.black]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _neonBlue),
                  ),
                  child: Column(
                    children: [
                      Text("FITNESS GRADE", style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 14)),
                      Text(level, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("SCORE: $average", style: GoogleFonts.rajdhani(color: _neonBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text("START ASSESSMENT", style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120, // Fixed height for carousel
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildAssessmentCard(context, 'PUSHUPS', Icons.fitness_center),
                      _buildAssessmentCard(context, 'SQUATS', Icons.accessibility_new),
                      _buildAssessmentCard(context, 'PLANK', Icons.timer),
                      _buildAssessmentCard(context, 'RUNNING', Icons.directions_run),
                      _buildAssessmentCard(context, 'SKIPPING', Icons.refresh),
                      _buildAssessmentCard(context, 'SIT_AND_REACH', Icons.height),
                      _buildAssessmentCard(context, 'STUDY_SESSION', Icons.menu_book), // New Study Task
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text("RECENT HISTORY", style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                   child: ListView.builder(
                      itemCount: (stats['history'] as List?)?.length ?? 0,
                      itemBuilder: (context, index) {
                         final history = (stats['history'] as List)[index];
                         final date = DateTime.tryParse(history['createdAt'] ?? '') ?? DateTime.now();
                         return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                               color: const Color(0xFF151520),
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                               children: [
                                  Icon(Icons.check_circle_outline, color: _neonBlue, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                     child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Text(history['type']?.toString().replaceAll('_', ' ') ?? 'UNKNOWN', style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold)),
                                           Text("${date.day}/${date.month} ${date.hour}:${date.minute}", style: GoogleFonts.rajdhani(color: Colors.white38, fontSize: 12)),
                                        ],
                                     ),
                                  ),
                                  Text("${history['score']} PTS", style: GoogleFonts.orbitron(color: _neonBlue, fontWeight: FontWeight.bold)),
                               ],
                            ),
                         );
                      },
                   ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutInputScreen(type: title)));
      },
      child: Container(
        width: 100, // Fixed width for horizontal list
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 30),
            const SizedBox(height: 8),
            Text(
               title.replaceAll('_', ' '), 
               textAlign: TextAlign.center,
               style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)
            ),
          ],
        ),
      ),
    );
  }
}
