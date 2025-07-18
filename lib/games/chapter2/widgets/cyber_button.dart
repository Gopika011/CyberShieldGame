import 'package:flutter/material.dart';

class CyberButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLarge;

  const CyberButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isLarge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? double.infinity : null,
      height: isLarge ? 60 : 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? const Color(0xFF00D4FF), 
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            (color ?? const Color(0xFF00D4FF)).withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color ?? const Color(0xFF00D4FF),
                fontSize: isLarge ? 18 : 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}