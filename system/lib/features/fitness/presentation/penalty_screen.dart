import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:system/features/fitness/data/fitness_service.dart';
import 'dart:async';

class PenaltyScreen extends ConsumerStatefulWidget {
  const PenaltyScreen({super.key});

  @override
  ConsumerState<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends ConsumerState<PenaltyScreen> {
  double _totalDistance = 0.0;
  bool _isTracking = false;
  Timer? _simTimer;

  @override
  void initState() {
    super.initState();
    _initTracking();
  }
  
  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }

  Future<void> _initTracking() async {
    // Simulation Mode
    setState(() => _isTracking = true);
    
    // Simulate running for demo purposes since GPS is disabled
    _simTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
       if (_totalDistance < 4000) {
          setState(() {
             _totalDistance += 50; // +50m per second simulation
          });
       } else {
          timer.cancel();
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4km Target
    final targetMeters = 4000; 
    final progress = (_totalDistance / targetMeters).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black, // Penalty Black
      body: Stack(
        children: [
          // Red Overlay for Urgency
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.red.withOpacity(0.2), Colors.black],
                radius: 1.5,
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                      "PENALTY QUEST", 
                      style: GoogleFonts.nosifer(color: Colors.red, fontSize: 32)
                   ),
                   const SizedBox(height: 16),
                   Text(
                      "SURVIVE", 
                      style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 16, letterSpacing: 4)
                   ),
                   
                   const SizedBox(height: 48),
                   
                   // Progress Circle
                   Stack(
                     alignment: Alignment.center,
                     children: [
                        SizedBox(
                          width: 200, height: 200,
                          child: CircularProgressIndicator(
                             value: progress,
                             color: Colors.red,
                             strokeWidth: 20,
                             backgroundColor: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                              Text(
                                 (_totalDistance / 1000).toStringAsFixed(2),
                                 style: GoogleFonts.orbitron(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                              Text("KM / 4.00 KM", style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 14)),
                              if (_isTracking)
                                 Text("(SIMULATION)", style: GoogleFonts.rajdhani(color: Colors.amber, fontSize: 10)),
                           ],
                        )
                     ],
                   ),
                   
                   const SizedBox(height: 48),
                   
                   GlassBox(
                      color: Colors.red.withOpacity(0.1),
                      child: Text(
                         "To restore your status, you must complete this run. The System is watching.",
                         textAlign: TextAlign.center,
                         style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
                      ),
                   ),
                   
                   const SizedBox(height: 20),
                   if (progress >= 1.0)
                      ElevatedButton(
                         onPressed: () => Navigator.pop(context), 
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                         child: const Text("PENALTY CLEARED", style: TextStyle(color: Colors.white))
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
