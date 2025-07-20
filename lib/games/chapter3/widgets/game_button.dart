import 'package:flutter/material.dart';
import 'theme.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isIconRight;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isIconRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: !isIconRight && icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: textColor,
            ),
          ),
          if (isIconRight && icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon),
          ],
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? DigitalTheme.primaryCyan,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
