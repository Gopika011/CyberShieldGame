import 'package:claude/components/custom_app_bar.dart';
import 'package:claude/models/chapter.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';

class ChaptersPage extends StatefulWidget {
  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  final GameState gameState = GameState();
  
  final List<Chapter> chapters = [
    Chapter(
      id: 1,
      title: "The Scholarship Trap",
      description: "Email phishing, fake links, urgency",
      story: "Arya receives an email saying she's selected for a prestigious internship. She's excited, but something feels off...",
      icon: Icons.email,
      color: Color(0xFF00D4FF),
    ),
    Chapter(
      id: 2,
      title: "Deals Too Good to Be True",
      description: "Fake e-commerce, public Wi-Fi, card safety",
      story: "Arya is waiting at a bus stop and sees a WhatsApp forward with '90% off on iPhones.' Tempted, she clicks.",
      icon: Icons.shopping_bag,
      color: Color(0xFF00D4FF),
    ),
    Chapter(
      id: 3,
      title: "The Impersonator",
      description: "Social media impersonation, DMs, fake profiles",
      story: "Arya gets a friend request from 'Rahul_2.0,' who looks like her classmate — but asks strange questions.",
      icon: Icons.people,
      color: Color(0xFF00D4FF),
    ),
    Chapter(
      id: 4,
      title: "The Fake Bank Call",
      description: "OTP scams, urgency pressure, trust manipulation",
      story: "Arya's dad gets a call saying his account will be blocked unless he shares the OTP. He asks Arya what to do.",
      icon: Icons.phone,
      color: Color(0xFF00D4FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Choose Your Chapter',
        showBackButton: true,
      ),
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Help Arya navigate through her digital day',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB8C6DB),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      return _buildChapterCard(chapters[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter) {
    bool isUnlocked = gameState.isChapterUnlocked(chapter.id);
    bool isCompleted = gameState.isChapterCompleted(chapter.id);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? const Color(0xFF00D4FF).withOpacity(0.5) : Color(0xFF404040),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isUnlocked ? const Color(0xFF00D4FF).withOpacity(0.1) : Colors.transparent,
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFF00D4FF) : Color(0xFF404040),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnlocked ? const Color(0xFF00D4FF).withOpacity(0.1) : Color(0xFF404040).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUnlocked ? const Color(0xFF00D4FF) : Color(0xFF404040),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    chapter.icon,
                    color: isUnlocked ? const Color(0xFF00D4FF) : Color(0xFF404040),
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chapter ${chapter.id -1}: ${chapter.title}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.white : Color(0xFF808080),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          if (isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF00FF88).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF00FF88), width: 1),
                              ),
                              child: Text(
                                'COMPLETED',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF00FF88),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (!isUnlocked)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF404040).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF404040), width: 1),
                              ),
                              child: Text(
                                'LOCKED',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF808080),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        chapter.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isUnlocked ? Color(0xFF00D4FF) : Color(0xFF606060),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        chapter.story,
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnlocked ? Color(0xFFB8C6DB) : Color(0xFF606060),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (isUnlocked)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF00D4FF)),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/chapter${chapter.id}');
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isCompleted ? 'Play Again' : 'Start Chapter',
                              style: TextStyle(color: const Color(0xFF00D4FF)),
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
    );
  }
}