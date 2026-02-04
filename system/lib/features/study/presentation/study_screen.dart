import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
       backgroundColor: const Color(0xFF0F0518),
       body: SafeArea(
          child: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("ARCHIVE / STUDY", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24, letterSpacing: 2)),
                   const SizedBox(height: 20),
                   
                   // FOCUS TIMER
                   Center(
                      child: GlassBox(
                         width: double.infinity,
                         padding: const EdgeInsets.all(24),
                         child: Column(
                            children: [
                               const Icon(Icons.timer_outlined, color: Colors.cyanAccent, size: 40),
                               const SizedBox(height: 8),
                               Text("FOCUS SESSION", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18)),
                               const SizedBox(height: 16),
                               Text("00:00:00", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 40, letterSpacing: 4)),
                               const SizedBox(height: 16),
                               ElevatedButton(
                                  onPressed: () {}, // TODO: Implement Timer Logic
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                                  child: Text("START", style: GoogleFonts.rajdhani(color: Colors.black, fontWeight: FontWeight.bold)),
                               ),
                            ],
                         ),
                      ),
                   ),
                   
                   const SizedBox(height: 32),
                   Text("RESOURCES", style: GoogleFonts.rajdhani(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 16),

                   Expanded(
                      child: ListView(
                         children: [
                            _buildResourceCard("Roadmap.sh", "Developer Roadmaps", "https://roadmap.sh", Colors.blue),
                            _buildResourceCard("Flutter Docs", "Official Documentation", "https://flutter.dev", Colors.cyan),
                            _buildResourceCard("LeetCode", "Algorithm Practice", "https://leetcode.com", Colors.orange),
                            _buildResourceCard("System Design", "Scalability Guide", "https://github.com/donnemartin/system-design-primer", Colors.purple),
                         ],
                      ),
                   ),
                ],
             ),
          ),
       ),
    );
  }

  Widget _buildResourceCard(String title, String desc, String url, Color color) {
     return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
           onTap: () => _launchUrl(url),
           child: GlassBox(
              color: color.withOpacity(0.05),
              child: Row(
                 children: [
                    Icon(Icons.link, color: color),
                    const SizedBox(width: 16),
                    Expanded(
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(title, style: GoogleFonts.rajdhani(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                             Text(desc, style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 12)),
                          ],
                       ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                 ],
              ),
           ),
        ),
     );
  }
}
