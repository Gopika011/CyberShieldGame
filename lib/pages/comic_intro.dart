import 'package:flutter/material.dart';

class ComicIntro extends StatefulWidget {
  final int chapterId;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;

  const ComicIntro({
    Key? key,
    required this.chapterId,
    required this.onComplete,
    this.onSkip,
  }) : super(key: key);

  @override
  State<ComicIntro> createState() => _ComicIntroState();
}

class _ComicIntroState extends State<ComicIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start fade in animation
    _fadeController.forward();
    
    // Auto-complete after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _getComicImagePath(int chapterId) {
    // Return appropriate comic image path based on chapter
    switch (chapterId) {
      case 1:
        return 'assets/images/chap1.png';
      case 2:
        return 'assets/images/chap2.png';
      case 3:
        return 'assets/images/chap3.png';
      case 4:
        return 'assets/images/chap4.png';
      default:
        return 'assets/images/chap1.png';
    }
  }

  void _handleSkip() {
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(202, 10, 21, 32),
            Color.fromARGB(206, 15, 27, 46),
            Color.fromARGB(158, 26, 35, 50),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Comic image with proper aspect ratio
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
                ),
                child: AspectRatio(
                  aspectRatio: 9 / 16, // Adjust this ratio based on your comic image dimensions
                  child: Image.asset(
                    _getComicImagePath(widget.chapterId),
                    fit: BoxFit.contain, // This maintains aspect ratio
                  ),
                ),
              ),
            ),
          ),
          
          // Skip button
          Positioned(
            top: 50,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: _handleSkip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}