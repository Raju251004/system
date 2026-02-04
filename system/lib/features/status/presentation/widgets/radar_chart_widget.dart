import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RadarChartWidget extends StatelessWidget {
  final Map<String, int> attributes;

  const RadarChartWidget({
    super.key,
    required this.attributes,
  });

  @override
  Widget build(BuildContext context) {
    // Normalizing values (Assuming max stat is roughly 100 for visualization, 
    // or we can allow it to scale dynamically. Let's cap visual at 100 but allow overflow)
    // Actually, getting key stats: Strength, Agility, Intelligence, Vitality, Sense
    
    final titles = attributes.keys.toList();
    final values = attributes.values.map((e) => e.toDouble()).toList();
    
    // We need at least 3 points for a radar chart
    if (titles.length < 3) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: const Color(0xFF2E86DE).withOpacity(0.4), // Jin-Woo Blue
              borderColor: const Color(0xFF00D2D3), // Neon Blue
              entryRadius: 3,
              dataEntries: values.map((e) => RadarEntry(value: e)).toList(),
              borderWidth: 2,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.white24),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: GoogleFonts.rajdhani(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          getTitle: (index, angle) {
            if (index < titles.length) return RadarChartTitle(text: titles[index].toUpperCase());
            return const RadarChartTitle(text: '');
          },
          tickCount: 1,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          tickBorderData: const BorderSide(color: Colors.white10),
          gridBorderData: const BorderSide(color: Colors.white12, width: 1),
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
