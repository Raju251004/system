import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/home/presentation/welcome_screen.dart';
import 'package:system/features/status/presentation/status_controller.dart';
import 'package:system/features/status/presentation/widgets/radar_chart_widget.dart';
import 'package:system/features/status/presentation/widgets/edit_profile_dialog.dart';
import 'dart:async';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  // Aesthetic Colors
  static const Color _bgDark = Color(0xFF000000); // Pitch black for System
  static const Color _cardBg = Color(0xFF0F0F1A);
  static const Color _accentBlue = Color(0xFF2E86DE); // Jin-Woo Blue
  static const Color _neonBlue = Color(0xFF00D2D3);
  static const Color _alertRed = Color(0xFFFF4757);
  static const Color _activeGreen = Color(0xFF00FF00); // Active Player Green

  Timer? _timer;
  Duration _timeUntilReset = const Duration(hours: 0, minutes: 0, seconds: 0);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _timeUntilReset = tomorrow.difference(now);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeUntilReset.inSeconds > 0) {
            _timeUntilReset = _timeUntilReset - const Duration(seconds: 1);
          } else {
            // Reset logic could go here
            final now = DateTime.now();
            final tomorrow = DateTime(now.year, now.month, now.day + 1);
            _timeUntilReset = tomorrow.difference(now);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statusControllerProvider);

    return Scaffold(
      backgroundColor: _bgDark,
      // Custom AppBar for Player Status
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                 border: Border.all(color: _activeGreen),
                 borderRadius: BorderRadius.circular(4),
                 color: _activeGreen.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(color: _activeGreen, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('ACTIVE PLAYER', style: GoogleFonts.rajdhani(color: _activeGreen, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white54),
            onPressed: () {
               showDialog(
                 context: context, 
                 builder: (context) => EditProfileDialog(
                    currentData: state.asData?.value ?? {}, 
                    onSave: (updates) {
                       ref.read(statusControllerProvider.notifier).updateProfile(updates);
                    }
                 ),
               );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: _accentBlue),
            onPressed: () =>
                ref.read(statusControllerProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: _alertRed),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).setUnauthenticated();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: state.when(
        data: (data) => _buildBody(data),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: _neonBlue)),
        error: (e, s) => Center(
          child: Text('ERROR: $e', style: TextStyle(color: _alertRed)),
        ),
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> data) {
    // Current Level & Rank
    final level = data['level'] ?? 1;
    final String rank = "E"; // Placeholder or derived from level
    final String currentTitle = "THE AWAKENED"; // Placeholder

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center stage alignment
        children: [
          
          // 1. Profile & Title Header
          Text(
             data['username']?.toUpperCase() ?? 'PLAYER',
             style: GoogleFonts.orbitron(
               fontSize: 24,
               fontWeight: FontWeight.bold,
               color: Colors.white,
               letterSpacing: 2
             ),
          ),
          const SizedBox(height: 8),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
             decoration: BoxDecoration(
               color: _accentBlue.withOpacity(0.2),
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: _accentBlue),
             ),
             child: Text(
               currentTitle,
               style: GoogleFonts.rajdhani(
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
                 fontSize: 12,
                 letterSpacing: 1.5,
               ),
             ),
          ),

          const SizedBox(height: 32),

          // 2. Rank & Level (Center Stage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               _buildCenterStat("LEVEL", "$level"),
               Container(height: 40, width: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 30)),
               _buildCenterStat("RANK", rank),
            ],
          ),

          const SizedBox(height: 32),

          // 3. XP Progress Bar (Neon Gradient)
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                      Text("EXP", style: GoogleFonts.rajdhani(color: Colors.white70, fontWeight: FontWeight.bold)),
                      Text("${data['xp'] ?? 0} / 1000", style: GoogleFonts.rajdhani(color: _neonBlue, fontWeight: FontWeight.bold)),
                   ],
                ),
                const SizedBox(height: 8),
                Container(
                   height: 6,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     color: Colors.white10,
                     borderRadius: BorderRadius.circular(3),
                   ),
                   child: LayoutBuilder(
                      builder: (context, constraints) {
                         double percent = ((data['xp'] ?? 0) / 1000).clamp(0.0, 1.0);
                         return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                               width: constraints.maxWidth * percent,
                               height: 6,
                               decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: const LinearGradient(
                                     colors: [_accentBlue, _neonBlue],
                                  ),
                                  boxShadow: [
                                     BoxShadow(color: _neonBlue.withOpacity(0.6), blurRadius: 6, spreadRadius: 1),
                                  ],
                               ),
                            ),
                         );
                      },
                   ),
                ),
             ],
          ),

          const SizedBox(height: 40),

          // 4. "Essence Scan" Radar Chart
          Text(
            "ESSENCE SCAN",
             style: GoogleFonts.rajdhani(
               color: Colors.white54,
               fontSize: 12,
               fontWeight: FontWeight.bold,
               letterSpacing: 3,
             ),
          ),
          const SizedBox(height: 16),
          // Mapping data to new keys: Strength (Physical), Intelligence (Mental), Technical, Habits, Consistency
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RadarChartWidget(
              attributes: {
                'PHY': data['strength'] ?? 10,
                'MEN': data['intelligence'] ?? 10,
                'TEC': data['agility'] ?? 10, // Mapping Agility to Technical/Studies
                'HAB': data['vitality'] ?? 10, // Mapping Vitality to Habits
                'CON': data['perception'] ?? 10, // Mapping Perception to Consistency
              },
            ),
          ),
          
          const SizedBox(height: 40),

          // 5. Time Remaining (Penalty Zone)
           Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: _alertRed.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
              color: _alertRed.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PENALTY ZERO',
                  style: GoogleFonts.rajdhani(
                    color: _alertRed,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDuration(_timeUntilReset),
                  style: GoogleFonts.orbitron(
                    color: _alertRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterStat(String label, String value) {
     return Column(
        children: [
           Text(label, style: GoogleFonts.rajdhani(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
           const SizedBox(height: 4),
           Text(value, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2, 
             shadows: [Shadow(color: _accentBlue.withOpacity(0.8), blurRadius: 20)]
           )),
        ],
     );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.rajdhani(
        color: Colors.white54,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 12,
      ),
    );
  }

  Widget _buildStatCard(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: _accentBlue,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value ?? 10}',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifItem(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: Colors.white54, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 14),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.rajdhani(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }
}
