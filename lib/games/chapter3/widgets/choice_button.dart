import 'package:flutter/material.dart';
import '../widgets/theme.dart';

class ChoiceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int index;
  final bool isEnabled;

  const ChoiceButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.index,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: DigitalTheme.cardBackground.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DigitalTheme.primaryCyan.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                // Choice indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DigitalTheme.primaryCyan,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Choice text
                Expanded(
                  child: Text(
                    text,
                    style: DigitalTheme.bodyStyle.copyWith(
                      color: DigitalTheme.secondaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Invisible overlay for tap handling
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isEnabled ? onPressed : null,
                splashColor: DigitalTheme.primaryCyan.withOpacity(0.1),
                highlightColor: DigitalTheme.primaryCyan.withOpacity(0.05),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}