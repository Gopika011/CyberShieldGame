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
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}


class DigitalButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF00D4FF);
    final secondaryColor = const Color(0xFF0099CC);
    
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: isPrimary ? primaryColor : primaryColor.withOpacity(0.6),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        gradient: isPrimary 
            ? LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.2),
                  secondaryColor.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: isPrimary 
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(
                    icon,
                    color: isPrimary ? primaryColor : primaryColor.withOpacity(0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                ],
                if (isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPrimary ? primaryColor : primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isPrimary ? primaryColor : primaryColor.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
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