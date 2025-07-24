import 'package:claude/games/chapter3/screens/level3_intro.dart';
import 'package:claude/games/chapter3/widgets/feedback_panel.dart';
import 'package:claude/games/chapter3/widgets/game_app_bar.dart';
import 'package:claude/games/chapter3/widgets/game_background.dart';
import 'package:claude/games/chapter3/widgets/game_button.dart';
import 'package:claude/games/chapter3/widgets/game_status_bar.dart';
import 'package:claude/games/chapter3/widgets/level_complete_card.dart';
import 'package:claude/games/chapter3/widgets/chat_message.dart';
import 'package:claude/games/chapter3/widgets/choice_button.dart';
import 'package:flutter/material.dart';
import '../widgets/theme.dart';
import 'level2_intro.dart';

class Level2 extends StatefulWidget {
  const Level2({super.key});

  @override
  State<Level2> createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  // Game state variables
  int currentPhase = 0;
  int score = 0;
  bool showFeedback = false;
  bool levelCompleted = false;
  String feedbackMessage = '';
  String feedbackType = '';

  // Game data
  final List<Map<String, dynamic>> phases = [
    {
      'message': 'Hey! Do you remember me? I sat behind you in class.',
      'choices': [
        {
          'text': 'Oh hi! Can you remind me your last name?',
          'correct': true,
          'feedback': 'Smart! Always verify identities before trusting strangers online.',
        },
        {
          'text': 'Yeah, of course!',
          'correct': false,
          'feedback': 'Oops! Don\'t pretend to know someone without verifying their identity.',
        },
        {
          'text': 'Send a selfie!',
          'correct': false,
          'feedback': 'Dangerous! Never ask for or send photos to strangers.',
        },
      ],
    },
    {
      'message': 'Can I get your number? I want to add you on WhatsApp.',
      'choices': [
        {
          'text': 'Sorry, I don\'t share my number here.',
          'correct': true,
          'feedback': 'Excellent! Keep personal information private until you\'re sure about the person.',
        },
        {
          'text': 'Sure, it\'s 9xxxxx.',
          'correct': false,
          'feedback': 'Risky! Never share your phone number with strangers online.',
        },
        {
          'text': 'Let\'s talk here first.',
          'correct': false,
          'feedback': 'Better to be cautious, but this still gives them a chance to pressure you.',
        },
      ],
    },
    {
      'message': 'Send a selfie right now 😄',
      'choices': [
        {
          'text': 'That\'s a weird request. No thanks.',
          'correct': true,
          'feedback': 'Perfect! Trust your instincts and don\'t share photos with strangers.',
        },
        {
          'text': 'Send a photo',
          'correct': false,
          'feedback': 'Never! Sharing photos with strangers can be dangerous and lead to misuse.',
        },
        {
          'text': 'Why?',
          'correct': false,
          'feedback': 'Even asking why gives them an opportunity to manipulate you.',
        },
      ],
    },
  ];

  // Game logic methods
  void handleChoice(int choiceIndex) {
    final choice = phases[currentPhase]['choices'][choiceIndex];
    
    setState(() {
      if (choice['correct']) {
        score++;
        feedbackType = 'success';
      } else {
        feedbackType = 'error';
      }
      feedbackMessage = choice['feedback'];
      showFeedback = true;
    });

    _processNextPhase();
  }

  void _processNextPhase() {
    Future.delayed(const Duration(seconds: 3), () {
      if (currentPhase >= phases.length - 1) {
        setState(() {
          levelCompleted = true;
        });
      } else {
        setState(() {
          currentPhase++;
          showFeedback = false;
        });
      }
    });
  }

  void retryPhase() {
    setState(() {
      showFeedback = false;
    });
  }

  // UI Builder methods
  Widget _buildChatArea() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ChatMessage(
            message: phases[currentPhase]['message'],
            isFromStranger: true,
            timestamp: DateTime.now(),
          ),
          const SizedBox(height: 24),
          
          if (showFeedback)
            GameFeedbackPanel(
              feedback: feedbackMessage,
              isSuccess: feedbackType == 'success',
              showFeedback: showFeedback,
              defaultMessage: 'ANALYZING THREAT LEVEL...',
            ),
          
          if (!showFeedback && !levelCompleted)
            _buildChoicesSection(),
        ],
      ),
    );
  }

  Widget _buildChoicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DigitalTheme.primaryCyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DigitalTheme.primaryCyan.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DigitalTheme.primaryCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology,
                  color: DigitalTheme.primaryCyan,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'SELECT DEFENSIVE ACTION',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...phases[currentPhase]['choices'].asMap().entries.map(
          (entry) => ChoiceButton(
            text: entry.value['text'],
            onPressed: () => handleChoice(entry.key),
            index: entry.key,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionCard() {
    if (!levelCompleted) return const SizedBox.shrink();
    
    return LevelCompletionCard(
      title: 'MISSION ACCOMPLISHED',
      message: score < 2 
          ? 'THREAT LEVEL: HIGH\nSome choices compromised security. Review protocols and retry.'
          : 'Excellent cyber defense! You successfully identified and neutralized social engineering threats.',
      score: score,
      maxScore: phases.length,
      nextButton: GameButton(
        text: 'NEXT LEVEL',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Level3Intro()),
          );
        },
        backgroundColor: DigitalTheme.primaryCyan,
        textColor: Colors.black,
        icon: Icons.arrow_forward,
      ),
      retryButton: score < 2 
          ? GameButton(
              text: 'RETRY MISSION',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Level2Intro()),
                );
              },
              backgroundColor: DigitalTheme.dangerRed,
              textColor: Colors.white,
              icon: Icons.refresh,
              isIconRight: false,
            )
          : null,
      tips: const [
        'Never share personal info with strangers',
        'Verify identities before trusting',
        'Don\'t send photos to unknown people',
        'If in doubt, block and report',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigitalTheme.darkBackground,
      appBar: const GameAppBar(title: 'CYBER SHIELD - CHAT DEFENDER'),
      body: GameBackground(
        child: Column(
          children: [
            GameStatusBar(
              levelName: 'Level 2 - Active',
              score: score,
              maxScore: phases.length,
            ),
            _buildChatArea(),
            _buildCompletionCard(),
          ],
        ),
      ),
    );
  }
}