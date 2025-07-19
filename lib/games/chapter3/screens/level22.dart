import 'package:flutter/material.dart';
import 'level2_intro.dart';
import 'level3_intro.dart';
import '../widgets/theme.dart';
import '../chapter3.dart';
import '../chapter3.dart';
import 'package:provider/provider.dart';

class Level2 extends StatefulWidget {
  const Level2({super.key});

  @override
  State<Level2> createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  int currentPhase = 0;
  int score = 0;
  bool showFeedback = false;
  bool levelCompleted = false;
  String feedbackMessage = '';
  String feedbackType = '';

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

  Widget _buildStatusBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DigitalTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DigitalTheme.primaryCyan),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DETECTION STATUS',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level 2 - Active',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'SCORE',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$score/${phases.length}',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DigitalTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: showFeedback
                ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                : DigitalTheme.primaryCyan,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: showFeedback
                      ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                      : DigitalTheme.primaryCyan,
                  width: 2,
                ),
                color: showFeedback
                    ? (feedbackType == 'success' ? DigitalTheme.successGreen.withOpacity(0.15) : DigitalTheme.dangerRed.withOpacity(0.15))
                    : DigitalTheme.primaryCyan.withOpacity(0.08),
              ),
              child: Icon(
                showFeedback
                    ? (feedbackType == 'success' ? Icons.verified_rounded : Icons.warning_amber_rounded)
                    : Icons.shield,
                color: showFeedback
                    ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                    : DigitalTheme.primaryCyan,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feedbackMessage.isEmpty ? 'ANALYZING THREAT LEVEL...' : feedbackMessage,
              textAlign: TextAlign.center,
              style: DigitalTheme.bodyStyle.copyWith(
                color: showFeedback
                    ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                    : DigitalTheme.primaryCyan,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigitalTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: DigitalTheme.surfaceBackground,
        elevation: 0,
        title: Text(
          'CYBER SHIELD - SECURE PROFILE',
          style: DigitalTheme.subheadingStyle.copyWith(
            color: DigitalTheme.primaryCyan,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: DigitalTheme.primaryCyan),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: DigitalTheme.primaryCyan),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStatusBar(),
          const SizedBox(height: 20),
          _buildFeedbackPanel(),
          const SizedBox(height: 30),

          // Chat Messages Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Threat message bubble
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: DigitalTheme.dangerRed,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DigitalTheme.primaryCyan, width: 1),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: DigitalTheme.cardBackground,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              border: Border.all(
                                color: DigitalTheme.dangerRed.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              phases[currentPhase]['message'],
                              style: DigitalTheme.bodyStyle.copyWith(
                                color: DigitalTheme.primaryText,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: DigitalTheme.dangerRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: DigitalTheme.primaryCyan.withOpacity(0.6),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: DigitalTheme.primaryCyan.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Choices
                if (!showFeedback && !levelCompleted)
                  Column(
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
                              style: DigitalTheme.bodyStyle.copyWith(
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
                        (entry) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: DigitalTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: DigitalTheme.primaryCyan.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: DigitalTheme.primaryCyan,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        entry.value['text'],
                                        style: DigitalTheme.bodyStyle.copyWith(
                                          color: DigitalTheme.primaryText,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => handleChoice(entry.key),
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                // Continue button
                if (showFeedback && !levelCompleted)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: retryPhase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DigitalTheme.cardBackground,
                          foregroundColor: DigitalTheme.primaryCyan,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: DigitalTheme.primaryCyan),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Level Completion
          if (levelCompleted)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DigitalTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DigitalTheme.successGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: DigitalTheme.successGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: DigitalTheme.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: DigitalTheme.successGreen.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.verified_user,
                      color: DigitalTheme.successGreen,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'LEVEL COMPLETED',
                    style: DigitalTheme.subheadingStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: DigitalTheme.successGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SECURITY SCORE: $score/${phases.length}',
                    style: DigitalTheme.bodyStyle.copyWith(
                      color: DigitalTheme.successGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: DigitalTheme.primaryCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'SECURITY PROTOCOLS',
                          style: DigitalTheme.bodyStyle.copyWith(
                            color: DigitalTheme.primaryCyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '• Never share personal info with strangers\n'
                          '• Verify identities before trusting\n'
                          '• Don\'t send photos to unknown people\n'
                          '• If in doubt, block and report',
                          style: DigitalTheme.bodyStyle.copyWith(
                            color: DigitalTheme.primaryText,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (score < 2) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: DigitalTheme.dangerRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: DigitalTheme.dangerRed),
                      ),
                      child: Text(
                        'THREAT LEVEL: HIGH\nSome choices compromised security. Review protocols and retry.',
                        style: DigitalTheme.bodyStyle.copyWith(
                          color: DigitalTheme.dangerRed,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Level2Intro()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DigitalTheme.dangerRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text(
                            'RETRY MISSION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Level3Intro()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'NEXT LEVEL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
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