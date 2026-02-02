import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isNumber;
  final VoidCallback? onTap;
  final bool readOnly;
  final IconData? suffixIcon;

  const OnboardingTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isNumber = false,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF9D4EDD);
    const Color inputBg = Color(0xFF1A0B2E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: accentPurple,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentPurple.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            readOnly: readOnly,
            onTap: onTap,
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.rajdhani(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: accentPurple.withValues(alpha: 0.5))
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
