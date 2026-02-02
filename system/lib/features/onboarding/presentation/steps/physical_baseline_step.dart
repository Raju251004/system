import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/onboarding/presentation/widgets/onboarding_text_field.dart';

class PhysicalBaselineStep extends StatelessWidget {
  final TextEditingController pushupsController;
  final TextEditingController squatsController;
  final TextEditingController situpsController;

  const PhysicalBaselineStep({
    super.key,
    required this.pushupsController,
    required this.squatsController,
    required this.situpsController,
  });

  static const Color _accentPurple = Color(0xFF9D4EDD);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('PHYSICAL BASELINE', 'Strength Assessment'),
          const SizedBox(height: 32),
          OnboardingTextField(
            label: 'PUSHUPS (MAX REPS)',
            hint: '0',
            controller: pushupsController,
            isNumber: true,
          ),
          const SizedBox(height: 16),
          OnboardingTextField(
            label: 'SQUATS (MAX REPS)',
            hint: '0',
            controller: squatsController,
            isNumber: true,
          ),
          const SizedBox(height: 16),
          OnboardingTextField(
            label: 'SIT-UPS (MAX REPS)',
            hint: '0',
            controller: situpsController,
            isNumber: true,
          ),
          const SizedBox(height: 24),
          // Chips for Habits could go here (Future Improvement)
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.rajdhani(color: _accentPurple, fontSize: 18),
        ),
      ],
    );
  }
}
