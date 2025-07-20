import 'package:flutter/material.dart';
import 'theme.dart';

class LevelCompletionCard extends StatelessWidget {
  final String title;
  final String message;
  final int score;
  final int maxScore;
  final Widget? nextButton;
  final Widget? retryButton;
  final List<String>? tips;

  const LevelCompletionCard({
    super.key,
    required this.title,
    required this.message,
    required this.score,
    required this.maxScore,
    this.nextButton,
    this.retryButton,
    this.tips,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = score >= (maxScore * 0.7); // 70% success threshold
    final color = isSuccess ? DigitalTheme.successGreen : DigitalTheme.dangerRed;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DigitalTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isSuccess ? Icons.security : Icons.warning_rounded,
            color: color,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: DigitalTheme.subheadingStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: DigitalTheme.bodyStyle.copyWith(
              color: color,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          if (tips != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'KEY LEARNINGS',
                    style: DigitalTheme.bodyStyle.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tips!.map((tip) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• $tip',
                      style: DigitalTheme.bodyStyle.copyWith(color: color),
                      textAlign: TextAlign.left,
                    ),
                  )),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          if (retryButton != null) ...[
            retryButton!,
            const SizedBox(height: 12),
          ],
          if (nextButton != null) nextButton!,
        ],
      ),
    );
  }
}