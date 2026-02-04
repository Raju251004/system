import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/assessment/presentation/assessment_controller.dart';

class WorkoutInputScreen extends ConsumerStatefulWidget {
  final String type; // PUSHUPS, RUNNING, etc.

  const WorkoutInputScreen({super.key, required this.type});

  @override
  ConsumerState<WorkoutInputScreen> createState() => _WorkoutInputScreenState();
}

class _WorkoutInputScreenState extends ConsumerState<WorkoutInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0518),
      appBar: AppBar(
        title: Text('${widget.type} ASSESSMENT', style: GoogleFonts.orbitron(fontSize: 18)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                _instructions(widget.type),
                style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ..._buildInputs(widget.type),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await ref.read(assessmentControllerProvider.notifier).submitAssessment(widget.type, _formData);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text("SUBMIT RESULT", style: GoogleFonts.orbitron(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _instructions(String type) {
    switch (type) {
      case 'PUSHUPS': return "Complete as many standard pushups as possible.";
      case 'SQUATS': return "Complete as many squats as possible.";
      case 'PLANK': return "Hold the plank position for as long as possible.";
      case 'RUNNING': return "Run a set distance and record the time.";
      case 'SKIPPING': return "Count successful skips and missed attempts.";
      case 'SIT_AND_REACH': return "Measure distance past toes in centimeters.";
      default: return "";
    }
  }

  List<Widget> _buildInputs(String type) {
    switch (type) {
      case 'PUSHUPS':
      case 'SQUATS':
        return [_buildTextField('reps', 'Number of Repetitions')];
      case 'PLANK':
        return [_buildTextField('seconds', 'Duration (Seconds)')];
      case 'RUNNING':
        return [
           _buildTextField('distance', 'Distance (km)'),
           const SizedBox(height: 10),
           _buildTextField('time', 'Time Taken (Seconds)'),
        ];
      case 'SKIPPING':
         return [
           _buildTextField('total', 'Total Attempts'),
           const SizedBox(height: 10),
           _buildTextField('missed', 'Missed Skips'),
         ];
      case 'SIT_AND_REACH':
         return [_buildTextField('cm', 'Distance (cm)')];
      default:
        return [];
    }
  }

  Widget _buildTextField(String key, String label) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      ),
      onSaved: (value) => _formData[key] = num.tryParse(value ?? '') ?? 0,
      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
    );
  }
}
