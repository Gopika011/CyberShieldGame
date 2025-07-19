import 'package:claude/pages/land.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';

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
                              'CHAPTER ${(chapterId -1).toString().padLeft(2, '0')}',
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
                                  
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chapter['story'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFB8C6DB),
                                              height: 1.6,
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                          // Training modules block
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
                                                ...(chapter['levels'] as List).map<Widget>((levelData) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 6),
                                                    child: _buildMissionLevel(
                                                      levelData['level'],
                                                      levelData['description'],
                                                      levelData['icon'],
                                                    ),
                                                  );
                                                }).toList(),
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
                        if (chapterId == 2) {
                          Navigator.pushNamed(context, '/chapter2/game').then((result) {
                            if (result == 'completed') {
                              Navigator.pop(context, 'completed');
                            }
                          });
                        } else if (chapterId == 4) {
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
                        (chapterId == 1 || chapterId == 2 || chapterId == 4 || chapterId == 3) ? 'START MISSION' : 'COMPLETE MISSION',
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
        'levels': [
          {'level': 'LEVEL 01', 'description': 'Email Header Analysis', 'icon': Icons.mark_email_read_outlined},
          {'level': 'LEVEL 02', 'description': 'Suspicious Link Detection', 'icon': Icons.link_off_outlined},
          {'level': 'LEVEL 03', 'description': 'Phishing Simulation', 'icon': Icons.security_outlined},
        ],
      },
      2: {
        'title': 'Deals Too Good to Be True',
        'story': 'While waiting at a bus stop, Arya sees a WhatsApp forward advertising \'90% off on iPhones.\' The deal is tempting, but the source seems questionable.',
        'icon': Icons.shopping_bag_outlined,
        'levels': [
          {'level': 'LEVEL 01', 'description': 'Deal or Deception', 'icon': Icons.warning_amber_outlined},
          {'level': 'LEVEL 02', 'description': 'Access Evaluation Module', 'icon': Icons.public_outlined},
          {'level': 'LEVEL 03', 'description': 'Network Risk Simulation', 'icon': Icons.wifi},
        ],
      },
      3: {
        'title': 'The Impersonator',
        'story': 'Arya receives a friend request from \'Rahul_2.0\' who appears to be her classmate, but asks strange personal questions that the real Rahul would never ask.',
        'icon': Icons.people_outline,
        'levels': [
          {'level': 'LEVEL 01', 'description': 'Profile Check Training', 'icon': Icons.account_circle_outlined},
          {'level': 'LEVEL 02', 'description': 'Chat Red Flags', 'icon': Icons.chat_bubble_outline},
          {'level': 'LEVEL 03', 'description': 'Report & Block Simulation', 'icon': Icons.block_outlined},
        ],
      },
      4: {
        'title': 'The Fake Bank Call',
        'story': 'Arya\'s father receives a call claiming his account will be blocked unless he shares his OTP. He turns to Arya for advice on how to handle the situation.',
        'icon': Icons.phone_outlined,
        'levels': [
          {'level': 'LEVEL 01', 'description': 'Interactive Detection Training', 'icon': Icons.psychology_outlined},
          {'level': 'LEVEL 02', 'description': 'Decision-Based Scenarios', 'icon': Icons.quiz_outlined},
        ],
      },
      5: {
        'title': 'The Final Test',
        'story': 'Arya faces her most challenging scenario yet - a sophisticated multi-layered attack that combines elements from all her previous encounters.',
        'icon': Icons.security_outlined,
        'levels': [
          {'level': 'LEVEL 01', 'description': 'Multi-Stage Threat Detection', 'icon': Icons.layers_outlined},
          {'level': 'LEVEL 02', 'description': 'Live Attack Simulation', 'icon': Icons.bug_report_outlined},
          {'level': 'LEVEL 03', 'description': 'Digital Safety Certification', 'icon': Icons.verified_user_outlined},
        ],
      },
    };
    return chapters[chapterId]!;
  }
}