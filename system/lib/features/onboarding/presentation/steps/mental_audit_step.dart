import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/onboarding/presentation/widgets/onboarding_text_field.dart';

class MentalAuditStep extends StatelessWidget {
  final String? selectedGoal;
  final ValueChanged<String?> onGoalChanged;
  final TextEditingController knownLanguagesController;
  final TextEditingController codingProfilesController;

  const MentalAuditStep({
    super.key,
    required this.selectedGoal,
    required this.onGoalChanged,
    required this.knownLanguagesController,
    required this.codingProfilesController,
  });

  static const Color _accentPurple = Color(0xFF9D4EDD);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('MENTAL AUDIT', 'Knowledge & Goals'),
          const SizedBox(height: 32),

          Text(
            'PRIMARY GOAL',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _accentPurple,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0B2E).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accentPurple.withValues(alpha: 0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGoal,
                hint: Text(
                  'Select Goal',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                dropdownColor: const Color(0xFF1A0B2E),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: _accentPurple),
                items:
                    [
                      'Web Development',
                      'App Development',
                      'AI / Machine Learning',
                      'Data Science',
                      'Cybersecurity',
                      'Competitive Programming',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: onGoalChanged,
              ),
            ),
          ),

          const SizedBox(height: 24),
          OnboardingTextField(
            label: 'KNOWN LANGUAGES / TECH',
            hint: 'Python, JS, Flutter...',
            controller: knownLanguagesController,
          ),
          const SizedBox(height: 16),
          OnboardingTextField(
            label: 'CODING PROFILES',
            hint: 'LeetCode / GitHub ID',
            controller: codingProfilesController,
          ),
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
