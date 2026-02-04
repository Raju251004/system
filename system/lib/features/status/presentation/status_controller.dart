import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/status_repository.dart';
import '../domain/user_model.dart';
import 'package:system/features/status/domain/user_model.dart';

final statusControllerProvider =
    AsyncNotifierProvider<StatusController, User>(
      StatusController.new,
    );

class StatusController extends AsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    return _fetchProfile();
  }

  Future<User> _fetchProfile() async {
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
