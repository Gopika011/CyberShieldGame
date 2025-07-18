import 'package:flutter/material.dart';

class Chapter4Fbutton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isAccept;
  const Chapter4Fbutton({super.key, required this.label, required this.onPressed, required this.isAccept});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAccept
                ? [Color(0xFF00D4FF), Color(0xFF00B8E6)]
                : [Color(0xFFFF4757), Color(0xFFE63946)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isAccept ? Color(0xFF00D4FF) : Color(0xFFFF4757),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isAccept ? Color(0x4D00D4FF) : Color(0x4DFF4757),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isAccept ? Color(0xFF0A1520) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.white54,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
