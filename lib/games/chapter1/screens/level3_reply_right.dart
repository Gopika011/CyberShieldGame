import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';
import '../widgets/digital_components.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/painters/grid_painter.dart';
import 'package:claude/services/game_state.dart' as app_state;
import 'package:claude/pages/chapters_page.dart';

class Level3ReplyRight extends StatefulWidget {
  final List<DialogueChallenge> dialogues;
  final Function(DialogueChallenge, DialogueOption) onOptionSelected;

  const Level3ReplyRight({
    Key? key,
    required this.dialogues,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<Level3ReplyRight> createState() => _Level3ReplyRightState();
}

class _Level3ReplyRightState extends State<Level3ReplyRight> {
  int currentDialogueIndex = 0;
  bool showingFeedback = false;
  DialogueOption? selectedOption;
  List<Map<String, dynamic>> results = [];
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();

  @override
  Widget build(BuildContext context) {
    if (levelCompleted) {
      return SummaryPage(
        results: results,
        totalQuestions: widget.dialogues.length,
        gameType: GameType.replyRight,
        onContinue: () {
          app_state.GameState().completeChapter(1);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ChaptersPage()),
            (route) => false,
          );
        },
        onRetry: () {
          setState(() {
            currentDialogueIndex = 0;
            showingFeedback = false;
            selectedOption = null;
            results.clear();
            levelCompleted = false;
          });
        },
        isLastGameInChapter: true,
      );
    }

    if (currentDialogueIndex >= widget.dialogues.length) {
      setState(() {
        levelCompleted = true;
      });
      return const SizedBox.shrink();
    }

    final currentDialogue = widget.dialogues[currentDialogueIndex];

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
                            'Scenario ${currentDialogueIndex + 1} of ${widget.dialogues.length}',
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
                        value: (currentDialogueIndex + 1) / widget.dialogues.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                
                // Scenario card
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
                                    Icons.chat_bubble_outline,
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
                                        'SOCIAL THREAT DETECTED',
                                        style: TextStyle(
                                          color: Color(0xFF00D4FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'REPLY RIGHT CHALLENGE',
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
                          
                          // Scenario description
                          Text(
                            currentDialogue.scenario,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB8C6DB),
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Suspicious message
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF4757).withOpacity(0.1),
                                  const Color(0xFFFFA502).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF4757).withOpacity(0.3),
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
                                        color: const Color(0xFFFF4757).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.warning,
                                        color: Color(0xFFFF4757),
                                        size: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'SUSPICIOUS MESSAGE',
                                      style: TextStyle(
                                        color: Color(0xFFFF4757),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  currentDialogue.message,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFB8C6DB),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Options or Feedback
                          Expanded(
                            child: showingFeedback
                                ? _buildFeedback(currentDialogue, selectedOption!)
                                : _buildOptions(currentDialogue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Next button (only shown during feedback)
                if (showingFeedback)
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextDialogue,
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
                        currentDialogueIndex < widget.dialogues.length - 1 ? 'NEXT SCENARIO' : 'MISSION COMPLETE',
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

  Widget _buildOptions(DialogueChallenge dialogue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How should Arya respond?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < dialogue.options.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectOption(dialogue, dialogue.options[i]),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0x05FFFFFF),
                            border: Border.all(
                              color: const Color(0xFF00D4FF).withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dialogue.options[i].text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(DialogueChallenge dialogue, DialogueOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feedback Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: option.isCorrect
                ? DigitalTheme.neonGreen.withOpacity(0.1)
                : DigitalTheme.dangerRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: option.isCorrect
                  ? DigitalTheme.neonGreen
                  : DigitalTheme.dangerRed,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                option.isCorrect ? Icons.check_circle : Icons.cancel,
                color: option.isCorrect
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
                      option.isCorrect ? 'Excellent Choice!' : 'Not the Best Choice',
                      style: DigitalTheme.subheadingStyle.copyWith(
                        color: option.isCorrect
                            ? DigitalTheme.neonGreen
                            : DigitalTheme.dangerRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.feedback,
                      style: DigitalTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),
      ],
    );
  }

  void _selectOption(DialogueChallenge dialogue, DialogueOption option) {
    setState(() {
      selectedOption = option;
      showingFeedback = true;
      results.add({
        'isCorrect': option.isCorrect,
        'question': dialogue.scenario,
        'answer': dialogue.options.firstWhere((o) => o.isCorrect).text,
        'userAnswer': option.text,
      });

      if(option.isCorrect){
        _audioEffects.playCorrect();
      }else{
        _audioEffects.playWrong();
      }
    });
    widget.onOptionSelected(dialogue, option);
  }

  void _nextDialogue() {
    if (currentDialogueIndex < widget.dialogues.length - 1) {
      setState(() {
        currentDialogueIndex++;
        showingFeedback = false;
        selectedOption = null;
      });
    } else {
      setState(() {
        levelCompleted = true;
      });
    }
  }
}