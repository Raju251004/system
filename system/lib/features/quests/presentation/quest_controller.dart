import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/data/quest_repository.dart';
import 'package:system/features/status/presentation/status_controller.dart';
import 'dart:async';

part 'quest_controller.g.dart';

@riverpod
class QuestController extends _$QuestController {
  
  @override
  Future<List<Quest>> build() async {
    // Initial fetch from backend
    return _fetchQuests();
  }

  Future<List<Quest>> _fetchQuests() async {
     final repository = ref.read(questRepositoryProvider);
     return repository.getDailyQuests();
  }

  Future<void> toggleQuest(String id) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic Update
    final questIndex = currentState.indexWhere((q) => q.id == id);
    if (questIndex == -1) return;
    
    final quest = currentState[questIndex];
    if (quest.isCompleted) return; // Already done

    // Toggle locally
    final updatedQuest = quest.copyWith(isCompleted: true);
    final updatedList = List<Quest>.from(currentState);
    updatedList[questIndex] = updatedQuest;
    state = AsyncData(updatedList);

    // Call Backend
    try {
       await ref.read(questRepositoryProvider).completeQuest(id);
       
       // Refresh User Status (XP, Level, etc.)
       ref.invalidate(statusControllerProvider); 
       
       // Refresh Quests to get latest state from backend (in case of side effects)
       // state = AsyncData(await _fetchQuests()); 
    } catch (e) {
       // Revert on failure
       state = AsyncData(currentState);
       print("Failed to complete quest: $e");
    }
  }

  // Debug tools removed for now, relying on backend logic.
  // We can re-introduce penalty logic later if needed on frontend,
  // but penalty should come from backend API response ideally.
}
