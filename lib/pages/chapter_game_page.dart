import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final Color gridColor;
  final double cellSize;

  GridPainter({required this.gridColor, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChapterGamePage extends StatelessWidget {
  final int chapterId;
  final GameState gameState = GameState();

  ChapterGamePage({required this.chapterId});

  @override
  Widget build(BuildContext context) {
    final chapter = _getChapterData(chapterId);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),
          
          // Cyber grid background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                gridColor: const Color(0x1A00D4FF),
                cellSize: 25,
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x05FFFFFF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF00D4FF).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF00D4FF),
                          ),
                          onPressed: () => Navigator.pop(context, 'updated'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHAPTER ${chapterId.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Color(0xFFB8C6DB),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chapter['title'].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Main content card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0x05FFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00D4FF).withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Top accent bar
                          Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00D4FF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Chapter icon and header
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00D4FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF00D4FF),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00D4FF).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            chapter['icon'],
                                            color: const Color(0xFF00D4FF),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'MISSION BRIEFING',
                                                style: TextStyle(
                                                  color: Color(0xFFB8C6DB),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                chapter['title'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Story description
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        chapter['story'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFB8C6DB),
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Mission levels
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0x05FFFFFF),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF00D4FF).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF00D4FF).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                Icons.layers_outlined,
                                                color: Color(0xFF00D4FF),
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'TRAINING MODULES',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFB8C6DB),
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _buildMissionLevel(
                                          'LEVEL 01',
                                          'Interactive Detection Training',
                                          Icons.psychology_outlined,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildMissionLevel(
                                          'LEVEL 02',
                                          'Decision-Based Scenarios',
                                          Icons.quiz_outlined,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildMissionLevel(
                                          'LEVEL 03',
                                          'Comprehensive Assessment',
                                          Icons.security_outlined,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Demo notice - only show for chapters 1-3
                                  if (chapterId != 4)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0x05FFFFFF),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFF00D4FF).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Color(0xFFB8C6DB),
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Interactive gameplay modules will be implemented here',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFB8C6DB),
                                              ),
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
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF00D4FF)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (chapterId == 4) {
                          // Navigate to the actual game for Chapter 4
                          Navigator.pushNamed(context, '/chapter4/game').then((result) {
                            if (result == 'completed') {
                              Navigator.pop(context, 'completed');
                            }
                          });
                        } else {
                          // For other chapters, just mark as completed
                          gameState.completeChapter(chapterId);
                          Navigator.pop(context, 'completed');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        chapterId == 4 ? 'START MISSION' : 'COMPLETE MISSION',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00D4FF),
                          letterSpacing: 1,
                        ),
                      ),
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

  Widget _buildMissionLevel(String level, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF00D4FF).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00D4FF),
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB8C6DB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getChapterData(int chapterId) {
    final chapters = {
      1: {
        'title': 'The Scholarship Trap',
        'story': 'Arya receives an email claiming she\'s selected for a prestigious internship. The offer seems too good to be true, and something feels off about the sender\'s credentials.',
        'icon': Icons.email_outlined,
      },
      2: {
        'title': 'Deals Too Good to Be True',
        'story': 'While waiting at a bus stop, Arya sees a WhatsApp forward advertising \'90% off on iPhones.\' The deal is tempting, but the source seems questionable.',
        'icon': Icons.shopping_bag_outlined,
      },
      3: {
        'title': 'The Impersonator',
        'story': 'Arya receives a friend request from \'Rahul_2.0\' who appears to be her classmate, but asks strange personal questions that the real Rahul would never ask.',
        'icon': Icons.people_outline,
      },
      4: {
        'title': 'The Fake Bank Call',
        'story': 'Arya\'s father receives a call claiming his account will be blocked unless he shares his OTP. He turns to Arya for advice on how to handle the situation.',
        'icon': Icons.phone_outlined,
      },
      5: {
        'title': 'The Final Test',
        'story': 'Arya faces her most challenging scenario yet - a sophisticated multi-layered attack that combines elements from all her previous encounters.',
        'icon': Icons.security_outlined,
      },
    };
    return chapters[chapterId]!;
  }
}