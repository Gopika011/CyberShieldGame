import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A1520),
            Color(0xFF0F1B2E),
            Color(0xFF1A2332),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF00D4FF).withOpacity(0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00D4FF).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPatternPainter(),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button with futuristic styling
                  if (showBackButton)
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF00D4FF).withOpacity(0.5),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF00D4FF).withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF00D4FF),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Logo and title section
                  Expanded(
                    child: Row(
                      children: [
                        // Shield icon
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF00D4FF),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFF00D4FF).withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00D4FF).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.security,
                            color: Color(0xFF00D4FF),
                            size: 24,
                          ),
                        ),
                        
                        SizedBox(width: 16),
                        
                        // Title section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Main title with enhanced styling
                              Text(
                                'CYBERSHIELD',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF00D4FF),
                                  letterSpacing: 2.0,
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF00D4FF).withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Subtitle with cyber effects
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF00FFE0).withOpacity(0.3),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFF00FFE0).withOpacity(0.05),
                                ),
                                child: Text(
                                  'ARYA\'S DIGITAL DAY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00FFE0),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status indicators
                  Container(
                    child: Row(
                      children: [
                        // Signal indicator
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF00FF88).withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xFF00FF88).withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.signal_cellular_alt,
                                color: Color(0xFF00FF88),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ONLINE',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00FF88),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for grid pattern
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF00D4FF).withOpacity(0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double gridSize = 20.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}