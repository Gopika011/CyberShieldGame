import 'package:claude/enums/games.dart';
import 'package:claude/models/takeaway_item.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/providers/takeaway_item_provider.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';
// import 'package:cyber_shield_audio/components/fbutton.dart';

class SummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final int totalQuestions;
  final GameType gameType;
  final VoidCallback? onContinue;
  final bool isLastGameInChapter;

  const SummaryPage({
    super.key,
    required this.results,
    required this.totalQuestions,
    required this.gameType,
    this.onContinue,
    this.isLastGameInChapter = false,
  });

  @override
  Widget build(BuildContext context) {
    final int correctAnswers = results.where((result) => result['isCorrect'] == true).length;
    final int wrongAnswers = results.where((result) => result['isCorrect'] == false).length;
    final double accuracy = (correctAnswers / totalQuestions) * 100;

    final List<TakeawayItem> takeaways = GameTakeawayProvider.getTakeaways(gameType);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1520),
      body: Stack(
        children: [
          // Background with cyberpunk grid
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    // Color(0xFF0A1520),
                    // Color(0xFF0F1B2E),
                    // Color(0xFF1A2332),
                    Color.fromARGB(202, 10, 21, 32),
                    Color.fromARGB(206, 15, 27, 46),
                    Color.fromARGB(158, 26, 35, 50),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: GridPainter(
                  gridColor: const Color(0x1A00D4FF),
                  cellSize: 25,
                ),
              ),
            ),
          ),
          
          // // Animated corner brackets
          // _buildCornerBrackets(),
          
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  
                  // Title with cyber styling
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF), width: 1),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x1A00D4FF),
                    ),
                    child: Text(
                      '${_getGameTitle(gameType)} SUMMARY',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Accuracy Section with futuristic progress bar
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0x05FFFFFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ACCURACY',
                              style: TextStyle(
                                color: Color(0xFF00D4FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              '${accuracy.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // Futuristic Progress Bar
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A2332),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3), width: 1),
                          ),
                          child: Stack(
                            children: [
                              // Progress fill
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: accuracy / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00D4FF), Color(0xFF00FFE0)],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00D4FF).withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Animated scanner line
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF00D4FF).withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Stats Cards with cyber design
                  Row(
                    children: [
                      Expanded(
                        child: _buildCyberStatCard('CORRECT', correctAnswers, const Color(0xFF00FF88)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCyberStatCard('WRONG', wrongAnswers, const Color(0xFFFF4757)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),

                  // Key Takeaways Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0x05FFFFFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF00D4FF), Color(0xFF00FFE0)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'KEY TAKEAWAYS',
                              style: TextStyle(
                                color: Color(0xFF00D4FF),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        ...takeaways.asMap().entries.map((entry) {
                          final index = entry.key;
                          final takeaway = entry.value;
                          return Column(
                            children: [
                              _buildCyberTakeawayItem(
                                takeaway.icon,
                                takeaway.title,
                                takeaway.description,
                              ),
                              if (index < takeaways.length - 1) const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),

                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  // Conditional rendering
                  if (isLastGameInChapter) 
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D4FF).withOpacity(0.1),
                          foregroundColor: const Color(0xFF00D4FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF00D4FF)),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'COMPLETE MISSION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    )
                    else if (onContinue != null) 
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D4FF),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'CONTINUE TO NEXT CHALLENGE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
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
    );
  }

  String _getGameTitle(GameType gameType) {
    switch (gameType) {
      case GameType.spamCall:
        return 'SPAM CALL CHALLENGE';
      case GameType.phishing:
        return 'PHISHING DETECTION';
      case GameType.socialEngineering:
        return 'SOCIAL ENGINEERING AWARENESS';
      case GameType.malware:
        return 'MALWARE PROTECTION';
      case GameType.ecommerceScam:
        return 'SHOP OR STOP';
      case GameType.appPermissions:
        return 'PERMISSION PATROL';
      case GameType.networkRisk:
        return 'WI-FI WOES';

      // default:
      //   return 'CYBER SECURITY CHALLENGE';
    }
  }

  // Widget _buildCornerBrackets() {
  //   return Stack(
  //     children: [
  //       // Top-left bracket
  //       Positioned(
  //         top: 20,
  //         left: 20,
  //         child: Container(
  //           width: 40,
  //           height: 40,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //               left: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //             ),
  //           ),
  //         ),
  //       ),
  //       // Top-right bracket
  //       Positioned(
  //         top: 20,
  //         right: 20,
  //         child: Container(
  //           width: 40,
  //           height: 40,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //               right: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //             ),
  //           ),
  //         ),
  //       ),
  //       // Bottom-left bracket
  //       Positioned(
  //         bottom: 20,
  //         left: 20,
  //         child: Container(
  //           width: 40,
  //           height: 40,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //               left: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //             ),
  //           ),
  //         ),
  //       ),
  //       // Bottom-right bracket
  //       Positioned(
  //         bottom: 20,
  //         right: 20,
  //         child: Container(
  //           width: 40,
  //           height: 40,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //               right: BorderSide(color: Color(0xFF00D4FF), width: 2),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCyberStatCard(String label, int value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
        color: accentColor.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: accentColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: accentColor.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberTakeawayItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF00D4FF).withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4FF).withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00D4FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFB8C6DB),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}