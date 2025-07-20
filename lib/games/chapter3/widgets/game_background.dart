import 'package:claude/pages/land.dart';
import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  final Widget child;

  const GameBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A1A2A),
                const Color(0xFF1A2A3A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Grid background painter
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(
              gridColor: const Color(0x1A00D4FF),
              cellSize: 25,
            ),
          ),
        ),
        // Main content
        child,
      ],
    );
  }
}