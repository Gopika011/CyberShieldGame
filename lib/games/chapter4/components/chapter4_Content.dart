import 'package:claude/enums/feedback_effect.dart';
import 'package:flutter/material.dart';

class Chapter4ContentCard extends StatelessWidget {
  final String contentText;
  final double screenWidth;
  final FeedbackEffect feedbackEffect;
  
  const Chapter4ContentCard({
    super.key, 
    required this.contentText, 
    required this.screenWidth,
    this.feedbackEffect = FeedbackEffect.none,
  });

  Color _getFeedbackBorderColor() {
    switch (feedbackEffect) {
      case FeedbackEffect.correct:
        return const Color(0xFF00FF88);
      case FeedbackEffect.wrong:
        return const Color(0xFFFF4757);
      case FeedbackEffect.timeout:
        return const Color(0xFFFF4757);
      case FeedbackEffect.none:
      default:
        return const Color(0xFF00D4FF);
    }
  }

  Color _getFeedbackAccentColor() {
    switch (feedbackEffect) {
      case FeedbackEffect.correct:
        return const Color(0xFF00FF88);
      case FeedbackEffect.wrong:
        return const Color(0xFFFF4757);
      case FeedbackEffect.timeout:
        return const Color(0xFFFF4757);
      case FeedbackEffect.none:
      default:
        return const Color(0xFF00D4FF);
    }
  }

  Color _getFeedbackBackgroundColor() {
    switch (feedbackEffect) {
      case FeedbackEffect.correct:
        return const Color(0xFF00FF88).withOpacity(0.1);
      case FeedbackEffect.wrong:
        return const Color(0xFFFF4757).withOpacity(0.1);
      case FeedbackEffect.timeout:
        return const Color(0xFFFF4757).withOpacity(0.1);
      case FeedbackEffect.none:
      default:
        return const Color(0x05FFFFFF);
    }
  }

  List<BoxShadow> _getFeedbackShadow() {
    Color shadowColor;
    switch (feedbackEffect) {
      case FeedbackEffect.correct:
        shadowColor = const Color(0xFF00FF88);
        break;
      case FeedbackEffect.wrong:
        shadowColor = const Color(0xFFFF4757);
        break;
      case FeedbackEffect.timeout:
        shadowColor = const Color(0xFFFF4757);
        break;
      case FeedbackEffect.none:
      default:
        shadowColor = const Color(0xFF00D4FF);
    }

    return [
      BoxShadow(
        color: shadowColor.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: -5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double maxCardWidth = 400;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: maxCardWidth,
      // constraints: BoxConstraints(maxWidth: maxCardWidth),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getFeedbackBackgroundColor(),
        border: Border.all(
          color: _getFeedbackBorderColor().withOpacity(0.5), 
          width: feedbackEffect != FeedbackEffect.none ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: _getFeedbackShadow(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top accent line
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2, 
            width: 60, 
            color: _getFeedbackAccentColor(),
          ),
          
          const SizedBox(height: 20),
          
          // Content text
          Text(
            contentText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB8C6DB),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Bottom accent line
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2, 
            width: 60, 
            color: _getFeedbackAccentColor(),
          ),
        ],
      ),
    );
  }
}