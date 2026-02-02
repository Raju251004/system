import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/home/presentation/welcome_screen.dart';
import 'package:system/core/presentation/main_scaffold.dart';
import 'package:system/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: SoloLevelingApp()));
}

class SoloLevelingApp extends StatelessWidget {
  const SoloLevelingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Leveling System',
      theme: AppTheme.darkTheme,
      home: const AuthCheckScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthCheckScreen extends ConsumerWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (status) {
        switch (status) {
          case AuthStatus.authenticated:
            return const MainScaffold();
          case AuthStatus.onboardingRequired:
            return const OnboardingScreen();
          case AuthStatus.unauthenticated:
            return const WelcomeScreen();
          case AuthStatus.initial:
            return const _LoadingScreen();
        }
      },
      loading: () => const _LoadingScreen(),
      error: (err, stack) {
        // On error, assume unauthenticated
        return const WelcomeScreen();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.systemBlue),
            const SizedBox(height: 24),
            Text(
              'INITIALIZING SYSTEM...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.systemBlue),
            ),
          ],
        ),
      ),
    );
  }
}
