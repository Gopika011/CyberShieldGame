import 'package:flutter/material.dart';
import '../theme/digital_theme.dart';

class DigitalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool glowEffect;
  final Color? borderColor;
  final bool futuristicFrame;

  const DigitalCard({
    Key? key,
    required this.child,
    this.padding,
    this.glowEffect = false,
    this.borderColor,
    this.futuristicFrame = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: DigitalTheme.cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? DigitalTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: glowEffect ? DigitalTheme.neonGlow : DigitalTheme.cardShadow,
      ),
      child: child,
    );

    if (futuristicFrame) {
      return FuturisticFrame(
        borderColor: borderColor ?? DigitalTheme.primaryCyan,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

class FuturisticFrame extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double borderWidth;

  const FuturisticFrame({
    Key? key,
    required this.child,
    this.borderColor,
    this.borderWidth = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? DigitalTheme.primaryCyan;
    
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: child,
        ),
        // Top-left corner with tech details
        Positioned(
          top: 0,
          left: 0,
          child: _buildTechCorner(color, true, true),
        ),
        // Top-right corner with tech details
        Positioned(
          top: 0,
          right: 0,
          child: _buildTechCorner(color, true, false),
        ),
        // Bottom-left corner with tech details
        Positioned(
          bottom: 0,
          left: 0,
          child: _buildTechCorner(color, false, true),
        ),
        // Bottom-right corner with tech details
        Positioned(
          bottom: 0,
          right: 0,
          child: _buildTechCorner(color, false, false),
        ),
      ],
    );
  }

  Widget _buildTechCorner(Color color, bool isTop, bool isLeft) {
    return Container(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: TechCornerPainter(
          color: color,
          isTop: isTop,
          isLeft: isLeft,
          borderWidth: borderWidth,
        ),
      ),
    );
  }
}

class TechCornerPainter extends CustomPainter {
  final Color color;
  final bool isTop;
  final bool isLeft;
  final double borderWidth;

  TechCornerPainter({
    required this.color,
    required this.isTop,
    required this.isLeft,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    if (isTop && isLeft) {
      // Top-left corner
      path.moveTo(0, 20);
      path.lineTo(0, 8);
      path.lineTo(8, 0);
      path.lineTo(20, 0);
      
      // Add tech details
      path.moveTo(4, 4);
      path.lineTo(12, 4);
      path.moveTo(4, 8);
      path.lineTo(8, 8);
    } else if (isTop && !isLeft) {
      // Top-right corner
      path.moveTo(size.width, 20);
      path.lineTo(size.width, 8);
      path.lineTo(size.width - 8, 0);
      path.lineTo(size.width - 20, 0);
      
      // Add tech details
      path.moveTo(size.width - 4, 4);
      path.lineTo(size.width - 12, 4);
      path.moveTo(size.width - 4, 8);
      path.lineTo(size.width - 8, 8);
    } else if (!isTop && isLeft) {
      // Bottom-left corner
      path.moveTo(0, size.height - 20);
      path.lineTo(0, size.height - 8);
      path.lineTo(8, size.height);
      path.lineTo(20, size.height);
      
      // Add tech details
      path.moveTo(4, size.height - 4);
      path.lineTo(12, size.height - 4);
      path.moveTo(4, size.height - 8);
      path.lineTo(8, size.height - 8);
    } else {
      // Bottom-right corner
      path.moveTo(size.width, size.height - 20);
      path.lineTo(size.width, size.height - 8);
      path.lineTo(size.width - 8, size.height);
      path.lineTo(size.width - 20, size.height);
      
      // Add tech details
      path.moveTo(size.width - 4, size.height - 4);
      path.lineTo(size.width - 12, size.height - 4);
      path.moveTo(size.width - 4, size.height - 8);
      path.lineTo(size.width - 8, size.height - 8);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DigitalButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isLoading;

  const DigitalButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<DigitalButton> createState() => _DigitalButtonState();
}

class _DigitalButtonState extends State<DigitalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: widget.isPrimary 
                    ? DigitalTheme.primaryGradient 
                    : LinearGradient(
                        colors: [
                          DigitalTheme.surfaceBackground,
                          DigitalTheme.cardBackground,
                        ],
                      ),
                borderRadius: BorderRadius.circular(8),
                border: widget.isPrimary 
                    ? null 
                    : Border.all(color: DigitalTheme.primaryCyan, width: 1),
                boxShadow: widget.isPrimary ? DigitalTheme.neonGlow : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: DigitalTheme.primaryText,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (widget.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DigitalTheme.primaryText,
                        ),
                      ),
                    )
                  else
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: DigitalTheme.primaryText,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DigitalProgressBar extends StatelessWidget {
  final double progress;
  final String label;
  final Color? color;

  const DigitalProgressBar({
    Key? key,
    required this.progress,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: DigitalTheme.bodyStyle),
            Text(
              '${(progress * 100).toInt()}%',
              style: DigitalTheme.bodyStyle.copyWith(
                color: color ?? DigitalTheme.primaryCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: DigitalTheme.surfaceBackground,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color ?? DigitalTheme.primaryCyan,
                    (color ?? DigitalTheme.primaryCyan).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? DigitalTheme.primaryCyan).withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DigitalStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;

  const DigitalStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FuturisticFrame(
      borderColor: color ?? DigitalTheme.primaryCyan,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (color ?? DigitalTheme.primaryCyan).withOpacity(0.1),
              DigitalTheme.cardBackground,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (color ?? DigitalTheme.primaryCyan).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? DigitalTheme.primaryCyan,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: DigitalTheme.captionStyle.copyWith(
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        value,
                        style: DigitalTheme.subheadingStyle.copyWith(
                          color: color ?? DigitalTheme.primaryCyan,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: DigitalTheme.captionStyle.copyWith(
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GlowingBorder extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double strokeWidth;

  const GlowingBorder({
    Key? key,
    required this.child,
    this.glowColor = DigitalTheme.primaryCyan,
    this.strokeWidth = 2,
  }) : super(key: key);

  @override
  State<GlowingBorder> createState() => _GlowingBorderState();
}

class _GlowingBorderState extends State<GlowingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}