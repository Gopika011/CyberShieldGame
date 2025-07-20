import 'package:flutter/material.dart';
import 'theme.dart';

class GameFeedbackPanel extends StatelessWidget {
  final String feedback;
  final bool isSuccess;
  final bool showFeedback;
  final String defaultMessage;

  const GameFeedbackPanel({
    super.key,
    required this.feedback,
    required this.isSuccess,
    required this.showFeedback,
    this.defaultMessage = 'ANALYZING PROFILES...',
  });

  @override
  Widget build(BuildContext context) {
    final color = showFeedback 
        ? (isSuccess ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
        : DigitalTheme.primaryCyan;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DigitalTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              color: color.withOpacity(0.15),
            ),
            child: Icon(
              showFeedback
                  ? (isSuccess ? Icons.verified_rounded : Icons.warning_amber_rounded)
                  : Icons.shield,
              color: color,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feedback.isEmpty ? defaultMessage : feedback,
            textAlign: TextAlign.center,
            style: DigitalTheme.bodyStyle.copyWith(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}