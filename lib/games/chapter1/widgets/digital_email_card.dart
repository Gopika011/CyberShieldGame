import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';
import '../widgets/digital_components.dart';

class DigitalEmailCard extends StatefulWidget {
  final Email email;
  final Function(Email, DropZoneType) onDrop;
  final bool showAnswer;

  const DigitalEmailCard({
    Key? key,
    required this.email,
    required this.onDrop,
    this.showAnswer = false,
  }) : super(key: key);

  @override
  State<DigitalEmailCard> createState() => _DigitalEmailCardState();
}

class _DigitalEmailCardState extends State<DigitalEmailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Draggable<Email>(
              data: widget.email,
              feedback: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 300,
                  child: _buildEmailContent(isDragging: true),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _buildEmailContent(),
              ),
              child: _buildEmailContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailContent({bool isDragging = false}) {
    final borderColor = widget.showAnswer
        ? (widget.email.isPhishing ? DigitalTheme.dangerRed : DigitalTheme.neonGreen)
        : (_isHovered ? DigitalTheme.primaryCyan : DigitalTheme.primaryCyan.withOpacity(0.3));

    return FuturisticFrame(
      borderColor: borderColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: DigitalTheme.cardGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: DigitalTheme.primaryCyan.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : _isHovered
                  ? [
                      BoxShadow(
                        color: DigitalTheme.primaryCyan.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: DigitalTheme.primaryCyan.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.email,
                    color: DigitalTheme.primaryCyan,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.showAnswer) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (widget.email.isPhishing 
                          ? DigitalTheme.dangerRed 
                          : DigitalTheme.neonGreen).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      widget.email.isPhishing ? Icons.warning : Icons.shield,
                      color: widget.email.isPhishing 
                          ? DigitalTheme.dangerRed 
                          : DigitalTheme.neonGreen,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Spacer(),
                Text(
                  _formatDate(DateTime.now()),
                  style: DigitalTheme.captionStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Sender
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: DigitalTheme.surfaceBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'From: ${widget.email.sender}',
                style: DigitalTheme.captionStyle.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subject
            Text(
              widget.email.subject,
              style: DigitalTheme.subheadingStyle.copyWith(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            // Preview
            Text(
              widget.email.preview,
              style: DigitalTheme.bodyStyle.copyWith(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Answer Section (if showing answers)
            if (widget.showAnswer) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DigitalTheme.darkBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (widget.email.isPhishing 
                        ? DigitalTheme.dangerRed 
                        : DigitalTheme.neonGreen).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.email.isPhishing ? '🚨' : '✅',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.email.isPhishing ? 'PHISHING EMAIL' : 'LEGITIMATE EMAIL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: widget.email.isPhishing 
                                ? DigitalTheme.dangerRed 
                                : DigitalTheme.neonGreen,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...widget.email.indicators.map((indicator) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: DigitalTheme.captionStyle.copyWith(fontSize: 10),
                          ),
                          Expanded(
                            child: Text(
                              indicator,
                              style: DigitalTheme.captionStyle.copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}