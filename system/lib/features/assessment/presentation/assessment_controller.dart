import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/assessment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../status/presentation/status_controller.dart';

part 'assessment_controller.g.dart';

@riverpod
class AssessmentController extends _$AssessmentController {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    return _fetchStats();
  }

  Future<Map<String, dynamic>> _fetchStats() async {
    final repository = ref.read(assessmentRepositoryProvider);
    return await repository.getStats();
  }

  Future<void> submitAssessment(String type, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repository = ref.read(assessmentRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.submitAssessment(type, data);
      
      // Invalidate Status Provider to reflect XP/Stat gains
      ref.invalidate(statusControllerProvider);

      return _fetchStats();
    });
  }
}
