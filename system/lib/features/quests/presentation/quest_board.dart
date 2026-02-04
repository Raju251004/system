import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/quests/presentation/quest_controller.dart';
import 'package:system/features/status/presentation/status_controller.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'dart:ui'; 

class QuestBoard extends ConsumerWidget {
  const QuestBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(questControllerProvider);
    final userAsync = ref.watch(statusControllerProvider);

    const Color bgDark = Color(0xFF0F0518);
    
    return Scaffold(
      backgroundColor: bgDark,
      body: Container(
        // Vibrant Background for Glass Effect
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0518),
              Color(0xFF1A1A2E),
              Color(0xFF2E0249), // Deep Purple
            ],
          ),
        ),
        child: SafeArea(
          child: questsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            data: (quests) {
              
              // Calculate Progress
              final total = quests.length;
              final completed = quests.where((q) => q.isCompleted).length;
              final progress = total == 0 ? 0.0 : completed / total;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Block
                    _buildHeader(context, userAsync, completed, total, progress),
                    
                    const SizedBox(height: 24),
                    
                    // Quest Lists
                    Text("DAILY MISSIONS", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    
                    Expanded(
                      child: ListView(
                        children: [
                           if (quests.any((q) => q.type == 'PHYSICAL')) ...[
                              _buildSectionTitle("PHYSICAL TRAINING", Colors.redAccent),
                              ...quests.where((q) => q.type == 'PHYSICAL').map((q) => _buildQuestCard(context, ref, q, Colors.redAccent)),
                           ],
                           
                           const SizedBox(height: 16),
                           
                           if (quests.any((q) => q.type == 'TECHNICAL')) ...[
                              _buildSectionTitle("TECHNICAL TRIALS", Colors.cyanAccent),
                              ...quests.where((q) => q.type == 'TECHNICAL').map((q) => _buildQuestCard(context, ref, q, Colors.cyanAccent)),
                           ],
                           
                           const SizedBox(height: 16),

                           if (quests.any((q) => q.type == 'STUDY')) ...[
                              _buildSectionTitle("INTELLECTUAL GROWTH", Colors.purpleAccent),
                              ...quests.where((q) => q.type == 'STUDY').map((q) => _buildQuestCard(context, ref, q, Colors.purpleAccent)),
                           ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue userAsync, int completed, int total, double progress) {
     final user = userAsync.asData?.value;
     final currentXp = user?.currentXp ?? 0;
     final xpToNext = user?.xpToNextLevel ?? 1000;
     
     return GlassBox(
       borderRadius: BorderRadius.circular(16),
       child: Column(
         children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("DAILY QUESTS", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                     Text("$completed / $total COMPLETED", style: GoogleFonts.rajdhani(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w600)),
                   ],
                 ),
                 CircularProgressIndicator(
                    value: progress,
                    color: Colors.blueAccent,
                    backgroundColor: Colors.white10,
                 ),
              ],
            ),
            const SizedBox(height: 16),
            // XP Bar
            ClipRRect(
               borderRadius: BorderRadius.circular(4),
               child: LinearProgressIndicator(
                  value: currentXp / xpToNext, // User XP Progress
                  color: Colors.amber,
                  backgroundColor: Colors.white10,
                  minHeight: 8,
               ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text("XP $currentXp / $xpToNext", style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 10)),
            ),
         ],
       ),
     );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(title, style: GoogleFonts.rajdhani(color: color, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildQuestCard(BuildContext context, WidgetRef ref, Quest quest, Color accentColor) {
    // Rank Color Logic
    Color rankColor;
    switch (quest.difficulty) {
       case 'S': rankColor = const Color(0xFFFFD700); break; // Gold
       case 'A': rankColor = Colors.redAccent; break;
       case 'B': rankColor = Colors.purpleAccent; break;
       case 'C': rankColor = Colors.blueAccent; break;
       case 'D': rankColor = Colors.greenAccent; break;
       default: rankColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassBox(
        color: quest.isCompleted ? Colors.black.withOpacity(0.6) : null,
        borderRadius: BorderRadius.circular(12),
        padding: EdgeInsets.zero, // Handle padding inside InkWell
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref.read(questControllerProvider.notifier).toggleQuest(quest.id);
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                    content: Text("Rank ${quest.difficulty} Cleared! +${quest.xp} XP", style: GoogleFonts.orbitron()),
                    backgroundColor: rankColor,
                    duration: const Duration(milliseconds: 1000),
                 )
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                   // Rank Badge
                   Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color: rankColor, width: 2),
                         color: rankColor.withOpacity(0.2),
                      ),
                      child: Center(
                         child: Text(
                            quest.difficulty,
                            style: GoogleFonts.orbitron(color: rankColor, fontWeight: FontWeight.bold),
                         ),
                      ),
                   ),
                   const SizedBox(width: 12),
                   
                   // Icon / Checkbox
                  Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: quest.isCompleted ? accentColor.withOpacity(0.2) : Colors.transparent,
                        border: Border.all(color: quest.isCompleted ? accentColor : Colors.white24),
                     ),
                     child: Icon(
                        quest.isCompleted ? Icons.check : Icons.priority_high,
                        color: quest.isCompleted ? accentColor : Colors.white24,
                        size: 16,
                     ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(quest.title, style: GoogleFonts.rajdhani(color: quest.isCompleted ? Colors.white38 : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                         const SizedBox(height: 4),
                         Text(quest.description, style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                  
                  // Rewards
                  Column(
                     children: [
                        Text("+${quest.xp} XP", style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                     ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
