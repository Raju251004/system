import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../status/data/status_repository.dart';

enum AuthStatus { initial, authenticated, unauthenticated, onboardingRequired }

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthStatus>(
  AuthStateNotifier.new,
);

class AuthStateNotifier extends AsyncNotifier<AuthStatus> {
  @override
  FutureOr<AuthStatus> build() async {
    // Check authentication status on app startup
    return _checkAuthStatus();
  }

  Future<AuthStatus> _checkAuthStatus() async {
    final authRepo = ref.read(authRepositoryProvider);
    final hasToken = await authRepo.hasToken();

    if (!hasToken) {
      return AuthStatus.unauthenticated;
    }

    // Validate token by trying to fetch profile
    try {
      final statusRepo = ref.read(statusRepositoryProvider);
      final profile = await statusRepo.getProfile();

      // Check if onboarding is completed
      // The backend now returns isOnboardingCompleted in the profile
      final isCompleted = profile['isOnboardingCompleted'] as bool? ?? false;

      if (isCompleted) {
        return AuthStatus.authenticated;
      } else {
        return AuthStatus.onboardingRequired;
      }
    } catch (e) {
      // Token is invalid or expired
      await authRepo.logout();
      return AuthStatus.unauthenticated;
    }
  }

  Future<void> setAuthenticated() async {
    state = const AsyncValue.data(AuthStatus.authenticated);
  }

  Future<void> setUnauthenticated() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.logout();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _checkAuthStatus());
  }
}
