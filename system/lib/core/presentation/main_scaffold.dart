import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/status/presentation/status_screen.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  // Aesthetic Colors (Mystic Portal Theme)
  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _navBg = Color(0xFF1A0B2E);
  static const Color _accentPurple = Color(0xFF9D4EDD);
  static const Color _neonPurple = Color(0xFFB000FF);

  final List<Widget> _screens = [
    const StatusScreen(), // Home / Status
    const Center(
      child: Text('QUESTS', style: TextStyle(color: Colors.white)),
    ), // Placeholder
    const Center(
      child: Text('INVENTORY', style: TextStyle(color: Colors.white)),
    ), // Placeholder
    const Center(
      child: Text('DUNGEON', style: TextStyle(color: Colors.white)),
    ), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _navBg,
          boxShadow: [
            BoxShadow(
              color: _neonPurple.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: _accentPurple.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _neonPurple,
          unselectedItemColor: Colors.white.withValues(alpha: 0.4),
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.orbitron(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          unselectedLabelStyle: GoogleFonts.rajdhani(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'STATUS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'QUESTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.backpack_outlined),
              activeIcon: Icon(Icons.backpack),
              label: 'INVENTORY',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.castle_outlined),
              activeIcon: Icon(Icons.castle),
              label: 'DUNGEON',
            ),
          ],
        ),
      ),
    );
  }
}
