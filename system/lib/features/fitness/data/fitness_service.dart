import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';

final fitnessServiceProvider = Provider<FitnessService>((ref) => FitnessService());

class FitnessService {
  // Stream<StepCount>? _stepCountStream;
  // Stream<PedestrianStatus>? _pedestrianStatusStream;

  // STEP COUNTING
  Stream<int> get stepStream {
    // Mock Stream
    return Stream.periodic(const Duration(seconds: 2), (i) => i * 10);
  }

  Future<bool> requestActivityPermission() async {
    return true; // Mock granted
  }

  // GPS / GEOLOCATOR
  Stream<dynamic> getPositionStream() {
    // Mock Stream
    return Stream.empty(); 
  }

  Future<bool> requestLocationPermission() async {
    return true; // Mock granted
  }

  Future<double> getDistanceBetween(double startLat, double startLng, double endLat, double endLng) async {
    return 0.0;
  }
}
