import 'package:flutter/material.dart';
import 'level3.dart';

class Level3Intro extends StatefulWidget {
  const Level3Intro({super.key});

  @override
  State<Level3Intro> createState() => _Level3IntroState();
}

class _Level3IntroState extends State<Level3Intro> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _buttonController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );
    _textController.forward().then((_) => _buttonController.forward());
  }

  @override
  void dispose() {
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void startLevel() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Level3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1B2E),
              Color(0xFF1A2332),
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          // Cyberpunk corner decorations
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF00D4FF),
                                    width: 1,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00D4FF).withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🛡️ Privacy Settings Challenge',
                                    style: TextStyle(
                                      color: Color(0xFF00D4FF),
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              // Corner brackets
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                      left: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                      right: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                      left: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                      right: BorderSide(color: Color(0xFF00D4FF), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2332).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              '🧠 Level 3: Who can see your info?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Main mission container with cyberpunk styling
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF1A2332).withOpacity(0.8),
                                  const Color(0xFF0F1419).withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00D4FF).withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status indicator
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Exposed',
                                      style: TextStyle(
                                        color: Color(0xFFFF4444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                const Text(
                                  'Arya\'s account is public, and strangers can see her posts and location!\n',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                
                                const Text(
                                  'Help her choose the safest privacy settings to protect her info from strangers and online threats.',
                                  style: TextStyle(
                                    color: Color(0xFFB0C4DE),
                                    fontSize: 15,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Mission objective with cyberpunk accent
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF00D4FF).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.security,
                                        color: Color(0xFF00D4FF),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          'Your mission: Make Arya\'s account as safe as possible!',
                                          style: TextStyle(
                                            color: Color(0xFF00D4FF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                  
                  const SizedBox(height: 48),
                  
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00D4FF),
                              Color(0xFF00B0FF),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D4FF).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: startLevel,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Level'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}