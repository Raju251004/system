import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/presentation/widgets/quest_card.dart';
import 'package:system/features/quests/presentation/quest_controller.dart';

class QuestScreen extends ConsumerWidget {
  const QuestScreen({super.key});

  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _systemBlue = Color(0xFF00AEEF);
  static const Color _penaltyRed = Color(0xFFFF0000);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questControllerProvider);
    
    // Check if we are in penalty mode
    final isPenalty = quests.length == 1 && quests.first.id == 'PENALTY';

    return Scaffold(
      backgroundColor: isPenalty ? const Color(0xFF220000) : _bgDark, // Red tint for penalty
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                          isPenalty ? 'PENALTY' : 'QUESTS',
                          style: GoogleFonts.orbitron(
                            color: isPenalty ? _penaltyRed : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          isPenalty ? 'SURVIVE' : 'SYSTEM ALERTS',
                          style: GoogleFonts.rajdhani(
                            color: isPenalty ? _penaltyRed.withOpacity(0.7) : _systemBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                     ],
                   ),
                   // Debug Button for Punishment (Hidden feature for testing)
                   if (!isPenalty)
                     IconButton(
                       icon: const Icon(Icons.bug_report, color: Colors.white24),
                       onPressed: () => ref.read(questControllerProvider.notifier).debugTriggerPunishment(),
                     ),
                   if (isPenalty)
                      IconButton(
                       icon: const Icon(Icons.restore, color: Colors.white24),
                       onPressed: () => ref.read(questControllerProvider.notifier).debugReset(),
                     ),
                ],
              ),
              
              const SizedBox(height: 32),

              // List
              Expanded(
                child: quests.isEmpty 
                ? Center(child: Text("NO QUESTS AVAILABLE", style: GoogleFonts.orbitron(color: Colors.white54)))
                : ListView.builder(
                  itemCount: quests.length,
                  itemBuilder: (context, index) {
                    return QuestCard(
                      quest: quests[index],
                      onToggle: () => ref.read(questControllerProvider.notifier).toggleQuest(quests[index].id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
