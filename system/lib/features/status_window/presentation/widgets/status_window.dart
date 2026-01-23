import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

class StatusWindow extends StatefulWidget {
  final Widget child;
  const StatusWindow({super.key, required this.child});

  @override
  State<StatusWindow> createState() => _StatusWindowState();
}

class _StatusWindowState extends State<StatusWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glitchAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Random glitch opacity
    _glitchAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));

    // Initial glitch on load
    _triggerGlitch();
  }

  void _triggerGlitch() async {
    for (int i = 0; i < 5; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: _random.nextInt(100)));
      if (!mounted) return;
      await _controller.forward();
      if (!mounted) return;
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Apply random offset during glitch
        double offsetX = _controller.isAnimating
            ? (_random.nextDouble() * 10 - 5)
            : 0;
        double offsetY = _controller.isAnimating
            ? (_random.nextDouble() * 10 - 5)
            : 0;

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Opacity(
            opacity: _controller.isAnimating ? _glitchAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
