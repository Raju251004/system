import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/main_scaffold.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/onboarding/data/assessment_repository.dart';
import 'package:system/features/onboarding/presentation/steps/essence_scan_step.dart';
import 'package:system/features/onboarding/presentation/steps/mental_audit_step.dart';
import 'package:system/features/onboarding/presentation/steps/physical_baseline_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Step 1 Controllers
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Step 2 Controllers
  final TextEditingController _pushupsController = TextEditingController();
  final TextEditingController _squatsController = TextEditingController();
  final TextEditingController _situpsController = TextEditingController();

  // Step 3 Controllers
  String? _selectedGoal;
  final TextEditingController _codingProfilesController =
      TextEditingController();
  final TextEditingController _knownLanguagesController =
      TextEditingController();

  // Aesthetic Colors (Mystic Portal Theme)
  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _accentPurple = Color(0xFF9D4EDD);
  static const Color _neonPurple = Color(0xFFB000FF);

  @override
  void dispose() {
    _pageController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _pushupsController.dispose();
    _squatsController.dispose();
    _situpsController.dispose();
    _codingProfilesController.dispose();
    _knownLanguagesController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      _submitAssessment();
    }
  }

  Future<void> _submitAssessment() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Awakening Protocol...')),
    );

    try {
      final assessmentRepo = ref.read(assessmentRepositoryProvider);

      final data = {
        'gender': _selectedGender,
        'dob': _dobController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'pushups': _pushupsController.text,
        'squats': _squatsController.text,
        'situps': _situpsController.text,
        'goal': _selectedGoal,
        'languages': _knownLanguagesController.text,
        'profiles': _codingProfilesController.text,
      };

      await assessmentRepo.submitAssessment(data);

      // Refresh Auth State to detect 'isOnboardingCompleted = true'
      // This will automatically trigger the redirect in AuthCheckScreen (main.dart)
      await ref.read(authStateProvider.notifier).refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _bgDark,
                    Color(0xFF1A0B2E), // Deep Purple
                    _bgDark,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      EssenceScanStep(
                        selectedGender: _selectedGender,
                        onGenderChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        dobController: _dobController,
                        heightController: _heightController,
                        weightController: _weightController,
                      ),
                      PhysicalBaselineStep(
                        pushupsController: _pushupsController,
                        squatsController: _squatsController,
                        situpsController: _situpsController,
                      ),
                      MentalAuditStep(
                        selectedGoal: _selectedGoal,
                        onGoalChanged: (value) {
                          setState(() {
                            _selectedGoal = value;
                          });
                        },
                        knownLanguagesController: _knownLanguagesController,
                        codingProfilesController: _codingProfilesController,
                      ),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'AWAKENING PROTOCOL',
            style: GoogleFonts.orbitron(
              color: _neonPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _accentPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentStep + 1) / _totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: _neonPurple,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: _neonPurple.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'STEP ${_currentStep + 1} OF $_totalSteps',
            style: GoogleFonts.rajdhani(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _accentPurple.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'BACK',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_neonPurple, _accentPurple],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: _neonPurple.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentStep == _totalSteps - 1 ? 'AWAKEN' : 'NEXT STEP',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
