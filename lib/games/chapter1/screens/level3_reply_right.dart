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

class _Level3ReplyRightState extends State<Level3ReplyRight>
    with TickerProviderStateMixin {
  int currentDialogueIndex = 0;
  bool showingFeedback = false;
  DialogueOption? selectedOption;
  List<Map<String, dynamic>> results = [];
  bool levelCompleted = false;

  late AnimationController _messageController;
  late AnimationController _optionsController;
  late Animation<double> _messageAnimation;
  late Animation<double> _optionsAnimation;

  @override
  void initState() {
    super.initState();
    _messageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _optionsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _messageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _messageController, curve: Curves.easeOut),
    );
    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionsController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _messageController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _optionsController.forward();
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (levelCompleted) {
      // Show summary page after completion
      return SummaryPage(
        results: results,
        totalQuestions: widget.dialogues.length,
        gameType: GameType.phishing,
        onContinue: () {
          app_state.GameState().completeChapter(1); // Unlock next chapter (The Impersonator)
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
        isLastGameInChapter: true, // Show 'Go to Next Chapter' button
      );
    }

    if (currentDialogueIndex >= widget.dialogues.length) {
      setState(() {
        levelCompleted = true;
      });
      return const SizedBox.shrink();
    }

    final currentDialogue = widget.dialogues[currentDialogueIndex];

    return DigitalCard(
      glowEffect: true,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 24),

              // Progress Indicator
              _buildProgressIndicator(),

              const SizedBox(height: 24),

              // Scenario
              _buildScenario(currentDialogue),

              const SizedBox(height: 24),

              // Message
              AnimatedBuilder(
                animation: _messageAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _messageAnimation.value)),
                    child: Opacity(
                      opacity: _messageAnimation.value,
                      child: _buildMessage(currentDialogue),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Options or Feedback
              AnimatedBuilder(
                animation: _optionsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _optionsAnimation.value)),
                    child: Opacity(
                      opacity: _optionsAnimation.value,
                      child: showingFeedback
                          ? _buildFeedback(currentDialogue, selectedOption!)
                          : _buildOptions(currentDialogue),
                    ),
                  );
                },
              ),

              // Bottom padding to ensure all content is accessible
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: DigitalTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: DigitalTheme.neonGlow,
          ),
          child: const Icon(
            Icons.chat_bubble_outline,
            color: DigitalTheme.primaryText,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reply Right',
                style: DigitalTheme.headingStyle,
              ),
              Text(
                'Choose the safest response to each situation',
                style: DigitalTheme.bodyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Scenario ${currentDialogueIndex + 1} of ${widget.dialogues.length}',
              style: DigitalTheme.captionStyle,
            ),
            Text(
              '${((currentDialogueIndex / widget.dialogues.length) * 100).toInt()}%',
              style: DigitalTheme.captionStyle.copyWith(
                color: DigitalTheme.primaryCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: DigitalTheme.surfaceBackground,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: currentDialogueIndex / widget.dialogues.length,
            child: Container(
              decoration: BoxDecoration(
                gradient: DigitalTheme.primaryGradient,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: DigitalTheme.primaryCyan.withOpacity(0.5),
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

  Widget _buildScenario(DialogueChallenge dialogue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DigitalTheme.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DigitalTheme.accentBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: DigitalTheme.accentBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              dialogue.scenario,
              style: DigitalTheme.bodyStyle.copyWith(
                color: DigitalTheme.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(DialogueChallenge dialogue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DigitalTheme.dangerRed.withOpacity(0.1),
            DigitalTheme.warningOrange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DigitalTheme.dangerRed.withOpacity(0.3),
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
                  color: DigitalTheme.dangerRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning,
                  color: DigitalTheme.dangerRed,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Suspicious Message',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.dangerRed,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            dialogue.message,
            style: DigitalTheme.bodyStyle.copyWith(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(DialogueChallenge dialogue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'How should Arya respond?',
          style: DigitalTheme.subheadingStyle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...dialogue.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(dialogue, option, index),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOptionCard(DialogueChallenge dialogue, DialogueOption option, int index) {
    return GestureDetector(
      onTap: () => _selectOption(dialogue, option),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              DigitalTheme.cardBackground,
              DigitalTheme.surfaceBackground,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          // Modified: Set a static border color for all options
          border: Border.all(
            color: DigitalTheme.secondaryText.withOpacity(0.5), // A neutral greyish color
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Option Number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: DigitalTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: const TextStyle(
                    color: DigitalTheme.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Option Text
            Expanded(
              child: Text(
                option.text,
                style: DigitalTheme.bodyStyle.copyWith(fontSize: 15),
              ),
            ),

            // Removed: Risk Indicator (small bar with round markings)
            // The following block is commented out to remove the risk indicator.
            /*
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRiskColor(option.riskLevel).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) => Icon(
                  Icons.circle,
                  size: 6,
                  color: i < option.riskLevel
                      ? _getRiskColor(option.riskLevel)
                      : DigitalTheme.secondaryText.withOpacity(0.3),
                )),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(DialogueChallenge dialogue, DialogueOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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

        const SizedBox(height: 20),

        // Explanation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DigitalTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DigitalTheme.accentBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why this matters:',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.accentBlue,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dialogue.explanation,
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.accentBlue.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Continue Button
        Center(
          child: DigitalButton(
            text: currentDialogueIndex < widget.dialogues.length - 1
                ? 'Next Scenario'
                : 'Complete Level',
            onPressed: _nextDialogue,
            isPrimary: true,
            icon: Icons.arrow_forward,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen() {
    return DigitalCard(
      glowEffect: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: DigitalTheme.primaryGradient,
                borderRadius: BorderRadius.circular(50),
                boxShadow: DigitalTheme.neonGlow,
              ),
              child: const Icon(
                Icons.check_circle,
                color: DigitalTheme.primaryText,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Level Complete!',
              style: DigitalTheme.headingStyle.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Arya learned how to respond safely to cyber threats!',
              style: DigitalTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

      _messageController.reset();
      _optionsController.reset();
      _startAnimations();
    } else {
      setState(() {
        levelCompleted = true;
      });
    }
  }

  Color _getRiskColor(int riskLevel) {
    switch (riskLevel) {
      case 1:
        return DigitalTheme.neonGreen;
      case 2:
        return DigitalTheme.primaryCyan;
      case 3:
        return DigitalTheme.warningOrange;
      case 4:
      case 5:
        return DigitalTheme.dangerRed;
      default:
        return DigitalTheme.secondaryText;
    }
  }
}