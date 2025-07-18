import 'package:claude/enums/feedback_effect.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FeedbackOverlay extends StatefulWidget {
  final FeedbackEffect currentFeedbackEffect;
  
  const FeedbackOverlay({
    super.key,
    required this.currentFeedbackEffect,
  });

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with TickerProviderStateMixin {
  late AnimationController _flashController;
  
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    
    // Quick color flash
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _flashAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flashController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(FeedbackOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.currentFeedbackEffect != oldWidget.currentFeedbackEffect) {
      if (widget.currentFeedbackEffect != FeedbackEffect.none) {
        _showFeedback();
      }
    }
  }

  void _showFeedback() {
    _flashController.reset();
    
    // Quick color flash
    _flashController.forward().then((_) {
      _flashController.reverse();
    });
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  Color _getFeedbackColor() {
    switch (widget.currentFeedbackEffect) {
      case FeedbackEffect.correct:
        return Colors.green;
      case FeedbackEffect.wrong:
        return Colors.red;
      case FeedbackEffect.timeout:
        return Colors.red;
      case FeedbackEffect.none:
      default:
        return Colors.transparent;
    }
  }

  String _getFeedbackText() {
    switch (widget.currentFeedbackEffect) {
      case FeedbackEffect.correct:
        return 'Correct!';
      case FeedbackEffect.wrong:
        return 'Wrong!';
      case FeedbackEffect.timeout:
        return 'Time Out!';
      case FeedbackEffect.none:
      default:
        return '';
    }
  }

  IconData _getFeedbackIcon() {
    switch (widget.currentFeedbackEffect) {
      case FeedbackEffect.correct:
        return Icons.check_circle;
      case FeedbackEffect.wrong:
        return Icons.cancel;
      case FeedbackEffect.timeout:
        return Icons.access_time;
      case FeedbackEffect.none:
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentFeedbackEffect == FeedbackEffect.none) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _flashController,
      builder: (context, child) {
        return _flashAnimation.value > 0.01
            ? Positioned.fill(
                child: Container(
                  color: _getFeedbackColor().withOpacity(_flashAnimation.value * 0.15),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}