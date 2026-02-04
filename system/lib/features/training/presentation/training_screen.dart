import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/study/presentation/study_screen.dart';
import 'package:system/features/fitness/presentation/penalty_screen.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF0F0518),
       appBar: AppBar(
          backgroundColor: const Color(0xFF0F0518),
          title: Text("TRAINING PROTOCOL", style: GoogleFonts.orbitron(color: Colors.white, letterSpacing: 2)),
          centerTitle: true,
          bottom: TabBar(
             controller: _tabController,
             indicatorColor: Colors.blueAccent,
             labelColor: Colors.blueAccent,
             unselectedLabelColor: Colors.white54,
             labelStyle: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
             tabs: const [
                Tab(text: "PHYSICAL", icon: Icon(Icons.fitness_center)),
                Tab(text: "INTELLECTUAL", icon: Icon(Icons.school)),
             ],
          ),
       ),
       body: TabBarView(
          controller: _tabController,
          children: [
             // Physical Tab (Fitness/Penalty)
             _buildPhysicalTab(),
             
             // Intellectual Tab (Study)
             const StudyScreen(),
          ],
       ),
    );
  }

  Widget _buildPhysicalTab() {
     // For now, allow direct access to Penalty (Run) screen
     // In future, this can be a dashboard showing steps first.
     return Padding(
       padding: const EdgeInsets.all(20.0),
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Icon(Icons.directions_run, color: Colors.orangeAccent, size: 80),
             const SizedBox(height: 24),
             Text("SURVIVAL RUN", style: GoogleFonts.nosifer(color: Colors.orange, fontSize: 24)),
             const SizedBox(height: 16),
             Text(
                "Complete the 4KM run to avoid penalty.", 
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 16)
             ),
             const SizedBox(height: 48),
             ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PenaltyScreen())
                   );
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.orange,
                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text("BEGIN RUN", style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
             )
          ],
       ),
     );
  }
}
