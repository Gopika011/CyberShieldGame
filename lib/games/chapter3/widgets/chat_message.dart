import 'package:flutter/material.dart';
import '../widgets/theme.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isFromStranger;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isFromStranger,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFromStranger ? DigitalTheme.dangerRed : DigitalTheme.primaryCyan,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DigitalTheme.primaryCyan, width: 1),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Message bubble
            Flexible(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: DigitalTheme.cardBackground.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: isFromStranger 
                            ? DigitalTheme.dangerRed.withOpacity(0.3)
                            : DigitalTheme.primaryCyan.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      message,
                      style: DigitalTheme.bodyStyle.copyWith(
                        color: DigitalTheme.secondaryText,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  // Threat indicator dot for stranger messages
                  if (isFromStranger)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: DigitalTheme.dangerRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Timestamp
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: DigitalTheme.primaryCyan.withOpacity(0.6),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryCyan.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}