import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/onboarding/presentation/widgets/onboarding_text_field.dart';

class EssenceScanStep extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final TextEditingController dobController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const EssenceScanStep({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.dobController,
    required this.heightController,
    required this.weightController,
  });

  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _accentPurple = Color(0xFF9D4EDD);
  static const Color _neonPurple = Color(0xFFB000FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('ESSENCE SCAN', 'Bio-Metric Analysis'),
          const SizedBox(height: 32),

          // Gender Dropdown
          Text(
            'GENDER',
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
                value: selectedGender,
                hint: Text(
                  'Select Gender',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                dropdownColor: const Color(0xFF1A0B2E),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: _accentPurple),
                items:
                    ['Male', 'Female', 'Other'].map((String value) {
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
                onChanged: onGenderChanged,
              ),
            ),
          ),

          const SizedBox(height: 24),

          OnboardingTextField(
            label: 'DATE OF BIRTH',
            hint: 'YYYY-MM-DD',
            controller: dobController,
            readOnly: true,
            suffixIcon: Icons.calendar_today,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: _neonPurple,
                        onPrimary: Colors.white,
                        surface: _bgDark,
                        onSurface: Colors.white,
                      ),
                      dialogBackgroundColor: _bgDark,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                dobController.text = "${picked.toLocal()}".split(' ')[0];
              }
            },
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OnboardingTextField(
                  label: 'HEIGHT (CM)',
                  hint: '175',
                  controller: heightController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OnboardingTextField(
                  label: 'WEIGHT (KG)',
                  hint: '70',
                  controller: weightController,
                  isNumber: true,
                ),
              ),
            ],
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
