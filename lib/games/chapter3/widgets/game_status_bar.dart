import 'package:flutter/material.dart';
import 'theme.dart';

// Shared Status Bar Component
class GameStatusBar extends StatelessWidget {
  final String levelName;
  final int score;
  final int maxScore;

  const GameStatusBar({
    super.key,
    required this.levelName,
    required this.score,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DigitalTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DigitalTheme.primaryCyan),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DETECTION STATUS',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                levelName,
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'SCORE',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$score/$maxScore',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}