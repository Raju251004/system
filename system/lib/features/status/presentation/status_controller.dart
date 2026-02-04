import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/status_repository.dart';

final statusControllerProvider =
    AsyncNotifierProvider<StatusController, Map<String, dynamic>>(
      StatusController.new,
    );

class StatusController extends AsyncNotifier<Map<String, dynamic>> {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    return _fetchProfile();
  }

  Future<Map<String, dynamic>> _fetchProfile() async {
    final repository = ref.read(statusRepositoryProvider);
    return await repository.getProfile();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfile());
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    state = const AsyncValue.loading();
    final repository = ref.read(statusRepositoryProvider);
    await AsyncValue.guard(() async {
      await repository.updateProfile(updates);
      // Refresh to get new data back
      return _fetchProfile();
    });
    // After update, refresh state
    ref.invalidateSelf();
  }
}
