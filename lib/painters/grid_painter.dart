import 'package:flutter/material.dart';

// Custom Painter for subtle background grid
class GridPainter extends CustomPainter {
  final Color gridColor;
  final double cellSize;

  GridPainter({required this.gridColor, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = gridColor;

    for (double i = 0; i < size.width; i += cellSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += cellSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    // Repaint only if the gridColor has changed
    return oldDelegate.gridColor != gridColor;
  }
}