import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/core/api/api_client.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quest_repository.g.dart';

@riverpod
QuestRepository questRepository(Ref ref) {
  return QuestRepository(ref.watch(apiClientProvider));
}

class QuestRepository {
  final ApiClient _client;

  QuestRepository(this._client);

  Future<List<Quest>> getDailyQuests() async {
    try {
      final response = await _client.get('/quests/daily');
      final data = response.data as List;
      return data.map((e) => Quest.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch daily quests: $e');
    }
  }

  Future<void> completeQuest(String questId) async {
    try {
      await _client.post('/quests/$questId/complete', {});
    } catch (e) {
      throw Exception('Failed to complete quest: $e');
    }
  }
}
