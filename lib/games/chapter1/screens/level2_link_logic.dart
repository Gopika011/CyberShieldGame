import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';
import '../widgets/digital_components.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/painters/grid_painter.dart';
import 'package:claude/games/chapter1/screens/level3_reply_right.dart';
import '../data/level_data.dart';

class Level2LinkLogic extends StatefulWidget {
  final List<LinkChallenge> links;
  final Function(LinkChallenge, bool) onLinkSelected;

  const Level2LinkLogic({
    Key? key,
    required this.links,
    required this.onLinkSelected,
  }) : super(key: key);

  @override
  State<Level2LinkLogic> createState() => _Level2LinkLogicState();
}

class _Level2LinkLogicState extends State<Level2LinkLogic> {
  int currentLinkIndex = 0;
  bool showingFeedback = false;
  bool? selectedAnswer;
  List<Map<String, dynamic>> results = [];
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();

  @override
  Widget build(BuildContext context) {
    if (levelCompleted) {
      // Show summary page after completion
      return SummaryPage(
        results: results,
        totalQuestions: widget.links.length,
        gameType: GameType.phishing,
        onContinue: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Level3ReplyRight(
                dialogues: LevelData.level3Dialogues,
                onOptionSelected: (dialogue, option) {},
              ),
            ),
          );
        },
        onRetry: () {
          setState(() {
            currentLinkIndex = 0;
            showingFeedback = false;
            selectedAnswer = null;
            results.clear();
            levelCompleted = false;
          });
        },
      );
    }

    if (currentLinkIndex >= widget.links.length) {
      // Mark level as completed and show summary
      setState(() {
        levelCompleted = true;
      });
      return const SizedBox.shrink();
    }

    final currentLink = widget.links[currentLinkIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A1520),
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
            child: Column(
              children: [
                // Progress indicator
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Link ${currentLinkIndex + 1} of ${widget.links.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (currentLinkIndex + 1) / widget.links.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                
                // Main card container
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0x05FFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Threat header
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF00D4FF).withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.link,
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
                                        'URL ANALYSIS REQUIRED',
                                        style: TextStyle(
                                          color: Color(0xFF00D4FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'LINK LOGIC CHALLENGE',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Instructions
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00D4FF).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF00D4FF),
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Look carefully at each URL. Check for misspellings, suspicious domains, and security indicators.',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFB8C6DB),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Challenge content
                          Expanded(
                            child: showingFeedback
                                ? _buildFeedback(currentLink, selectedAnswer!)
                                : _buildLinkChallenge(currentLink),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Continue button (only shown during feedback)
                if (showingFeedback)
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        foregroundColor: const Color(0xFF0A1520),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        currentLinkIndex < widget.links.length - 1 ? 'NEXT LINK' : 'MISSION COMPLETE',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkChallenge(LinkChallenge link) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Is this URL legitimate or fake?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // URL Display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DigitalTheme.accentBlue.withOpacity(0.1),
                DigitalTheme.accentBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DigitalTheme.accentBlue.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DigitalTheme.accentBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.language,
                      color: DigitalTheme.accentBlue,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'WEBSITE URL',
                    style: TextStyle(
                      color: DigitalTheme.accentBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // URL Text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1520).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: DigitalTheme.accentBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  link.displayUrl,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                    color: DigitalTheme.accentBlue,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                link.description,
                style: TextStyle(
                  color: DigitalTheme.accentBlue,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Answer Buttons
        Row(
          children: [
            Expanded(
              child: _buildAnswerButton(
                'Legitimate',
                Icons.shield,
                DigitalTheme.neonGreen,
                () => _selectAnswer(link, true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnswerButton(
                'Fake',
                Icons.warning,
                DigitalTheme.dangerRed,
                () => _selectAnswer(link, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(LinkChallenge link, bool userAnswer) {
    final isCorrect = userAnswer == link.isLegitimate;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feedback Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCorrect 
                ? DigitalTheme.neonGreen.withOpacity(0.1)
                : DigitalTheme.dangerRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect 
                  ? DigitalTheme.neonGreen
                  : DigitalTheme.dangerRed,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect 
                    ? DigitalTheme.neonGreen
                    : DigitalTheme.dangerRed,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Correct!' : 'Incorrect',
                      style: DigitalTheme.subheadingStyle.copyWith(
                        color: isCorrect 
                            ? DigitalTheme.neonGreen
                            : DigitalTheme.dangerRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.isLegitimate 
                          ? 'This URL is legitimate'
                          : 'This URL is fake/malicious',
                      style: DigitalTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Indicators
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF00D4FF).withOpacity(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF), width: 1),
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF00D4FF).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF00D4FF),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "KEY INDICATORS",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D4FF),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...link.indicators.map((indicator) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: const TextStyle(
                        color: Color(0xFFB8C6DB),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        indicator,
                        style: const TextStyle(
                          color: Color(0xFFB8C6DB),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        
        const Spacer(),
      ],
    );
  }

  void _selectAnswer(LinkChallenge link, bool answer) {
    setState(() {
      selectedAnswer = answer;
      showingFeedback = true;
      results.add({
        'isCorrect': answer == link.isLegitimate,
        'question': link.displayUrl,
        'answer': link.isLegitimate ? 'Legitimate' : 'Fake',
        'userAnswer': answer ? 'Legitimate' : 'Fake',
      });

      if(answer == link.isLegitimate){
        _audioEffects.playCorrect();
      }else{
        _audioEffects.playWrong();
      }
    });
    widget.onLinkSelected(link, answer == link.isLegitimate);
  }

  void _nextLink() {
    if (currentLinkIndex < widget.links.length - 1) {
      setState(() {
        currentLinkIndex++;
        showingFeedback = false;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        levelCompleted = true;
      });
    }
  }
}