import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'dart:async';

part 'quest_controller.g.dart';

@riverpod
class QuestController extends _$QuestController {
  
  // Hardcoded daily quests
  final List<Quest> _dailyQuests = [
    const Quest(
      id: '1',
      title: 'STRENGTH TRAINING [DAILY]',
      description: '100 Pushups\n100 Situps\n100 Squats\n10km Run',
      reward: 'Recover Fatigue, +3 Stat Points',
      difficulty: 'E',
      isCompleted: false,
    ),
    const Quest(
      id: '2',
      title: 'MEDITATION',
      description: 'Clear your mind for 15 minutes.',
      reward: '+1 Intelligence',
      difficulty: 'D',
      isCompleted: false,
    ),
    const Quest(
      id: '3',
      title: 'CODE REVIEW',
      description: 'Review 3 Pull Requests on GitHub.',
      reward: '+2 Intelligence',
      difficulty: 'C',
      isCompleted: false,
    ),
  ];

  final Quest _penaltyQuest = const Quest(
      id: 'PENALTY',
      title: 'PENALTY QUEST: SURVIVAL',
      description: 'The system has penalized you for failing the daily missions.\n\nOBJECTIVE: Survive against the centipedes for 4 hours OR Run 10km immediately.',
      reward: 'Return to Normal State',
      difficulty: 'S',
      isCompleted: false,
  );

  Timer? _timer;

  @override
  List<Quest> build() {
    // Start a timer to check for midnight/punishment logic
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkPunishmentCondition();
    });
    ref.onDispose(() => _timer?.cancel());
    
    // Initial State: Daily Quests
    return _dailyQuests; 
  }

  void toggleQuest(String id) {
    if (state.isEmpty) return;
    
    // If getting punished, only penalty quest matters
    if (state.length == 1 && state.first.id == 'PENALTY') {
       if (state.first.id == id) {
          // If they complete the penalty, they are forgiven? 
          // For now, let's just toggle it.
          // Implementing "Complete Penalty" -> Reset to empty or standard state?
          state = [state.first.copyWith(isCompleted: !state.first.isCompleted)];
          if (state.first.isCompleted) {
             // Punishment Over.
             // But daily quests are still failed? Or we give them a fresh set?
             // Let's restore dailies as completed or just empty for the day.
             // For gameplay loop, let's just clear the penalty.
             state = []; // Cleared for the day
          }
       }
       return;
    }

    final newState = state.map((q) {
      if (q.id == id) {
        return q.copyWith(isCompleted: !q.isCompleted);
      }
      return q;
    }).toList();
    
    state = newState;
  }

  void _checkPunishmentCondition() {
    final now = DateTime.now();
    // Logic: If it's past 00:00 (Midnight) AND Daily quests are NOT complete.
    // For demo purposes, let's say "Midnight" is defined by a debug flag or strict time.
    // Strict time: if (now.hour == 0 && now.minute == 0) -> precise trigger.
    
    // Check if daily quests are incomplete
    // We need to know if we are already punished.
    bool isPunished = state.length == 1 && state.first.id == 'PENALTY';
    if (isPunished) return;

    // Check if dailies are done
    bool allDailyDone = _dailyQuests.every((q) {
       // Find the quest in current state
       final currentQ = state.firstWhere((element) => element.id == q.id, orElse: () => q);
       return currentQ.isCompleted;
    });

    if (!allDailyDone) {
       // If it is midnight (or we trigger it manually for testing)
       if (now.hour == 0 && now.minute == 0) {
          // Trigger Punishment!
          state = [_penaltyQuest];
       }
    }
  }

  // Debug tool to force punishment
  void debugTriggerPunishment() {
    state = [_penaltyQuest];
  }

  void debugReset() {
    state = _dailyQuests;
  }
}
