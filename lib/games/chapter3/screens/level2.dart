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

  Widget _buildCornerDecoration() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: DigitalTheme.primaryCyan, width: 3),
            left: BorderSide(color: DigitalTheme.primaryCyan, width: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomRightCorner() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: DigitalTheme.primaryCyan, width: 3),
            right: BorderSide(color: DigitalTheme.primaryCyan, width: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DigitalTheme.surfaceBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: showFeedback
                      ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                      : DigitalTheme.primaryCyan,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: showFeedback
                        ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                        : DigitalTheme.primaryCyan,
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: showFeedback
                            ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                            : DigitalTheme.primaryCyan,
                        width: 3,
                      ),
                      color: DigitalTheme.surfaceBackground,
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
                  const SizedBox(height: 20),
                  Text(
                    feedbackMessage.isEmpty ? 'ANALYZING THREAT LEVEL...' : feedbackMessage,
                    textAlign: TextAlign.center,
                    style: DigitalTheme.headingStyle.copyWith(
                      color: showFeedback
                          ? (feedbackType == 'success' ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                          : DigitalTheme.primaryCyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildCornerDecoration(),
          _buildBottomRightCorner(),
        ],
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
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [DigitalTheme.dangerRed, DigitalTheme.dangerRed.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: DigitalTheme.primaryCyan, width: 1),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: DigitalTheme.dangerRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: DigitalTheme.darkBackground, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rahul_2.0',
                    style: DigitalTheme.subheadingStyle.copyWith(
                      color: DigitalTheme.primaryCyan,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: DigitalTheme.dangerRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'THREAT DETECTED',
                      style: DigitalTheme.bodyStyle.copyWith(
                        color: DigitalTheme.primaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DigitalTheme.primaryCyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: DigitalTheme.primaryCyan),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DigitalTheme.primaryCyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: DigitalTheme.primaryCyan),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: DigitalTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            // Futuristic Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DigitalTheme.surfaceBackground,
                border: Border(
                  bottom: BorderSide(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
                ),
              ),
              child: Row(
                children: [
                  // Score indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [DigitalTheme.primaryCyan, DigitalTheme.primaryCyan.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: DigitalTheme.primaryCyan.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'SCORE: $score/${phases.length}',
                          style: DigitalTheme.bodyStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Progress bar
                  Expanded(
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: DigitalTheme.surfaceBackground,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (currentPhase + 1) / phases.length,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [DigitalTheme.primaryCyan, DigitalTheme.primaryCyan.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: DigitalTheme.primaryCyan.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Phase indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [DigitalTheme.primaryCyan.withOpacity(0.8), DigitalTheme.primaryCyan.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: DigitalTheme.primaryCyan.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.security, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'PHASE ${currentPhase + 1}/${phases.length}',
                          style: DigitalTheme.bodyStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Chat Messages Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.05,
                    colorFilter: ColorFilter.mode(
                      DigitalTheme.primaryCyan.withOpacity(0.1),
                      BlendMode.overlay,
                    ),
                  ),
                ),
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
                            gradient: LinearGradient(
                              colors: [DigitalTheme.dangerRed, DigitalTheme.dangerRed.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(12),
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
                                  color: DigitalTheme.surfaceBackground,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    color: DigitalTheme.dangerRed.withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: DigitalTheme.dangerRed.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  phases[currentPhase]['message'],
                                  style: DigitalTheme.bodyStyle.copyWith(
                                    color: Colors.white,
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
                                  decoration: const BoxDecoration(
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

                    // Timestamp with tech styling
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
                            style: DigitalTheme.bodyStyle.copyWith(
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

                    // Feedback Panel
                    if (showFeedback)
                      _buildFeedbackPanel(),

                    // Choices with futuristic styling
                    if (!showFeedback && !levelCompleted)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  DigitalTheme.primaryCyan.withOpacity(0.1),
                                  DigitalTheme.primaryCyan.withOpacity(0.1).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: DigitalTheme.primaryCyan.withOpacity(0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: DigitalTheme.primaryCyan.withOpacity(0.1),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: DigitalTheme.primaryCyan.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.psychology,
                                    color: DigitalTheme.primaryCyan,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'SELECT DEFENSIVE ACTION',
                                  style: DigitalTheme.headingStyle.copyWith(
                                    color: DigitalTheme.primaryCyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
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
                                      gradient: LinearGradient(
                                        colors: [
                                          DigitalTheme.surfaceBackground,
                                          DigitalTheme.surfaceBackground,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: DigitalTheme.primaryCyan.withOpacity(0.3),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: DigitalTheme.primaryCyan.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                        ),
                                      ],
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
                                              color: Colors.white,
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
                                        borderRadius: BorderRadius.circular(15),
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

                    // Continue button with futuristic styling
                    if (showFeedback && !levelCompleted)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: retryPhase,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: DigitalTheme.primaryCyan,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: const BorderSide(
                                  color: DigitalTheme.primaryCyan,
                                  width: 2,
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'CONTINUE',
                                    style: DigitalTheme.headingStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward),
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

            // Level Completion with futuristic styling
            if (levelCompleted)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      DigitalTheme.successGreen.withOpacity(0.9),
                      DigitalTheme.primaryCyan.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: DigitalTheme.primaryCyan),
                  boxShadow: [
                    BoxShadow(
                      color: DigitalTheme.successGreen.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'MISSION ACCOMPLISHED',
                      style: DigitalTheme.headingStyle.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SECURITY SCORE: $score/${phases.length}',
                      style: DigitalTheme.bodyStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'SECURITY PROTOCOLS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '• Never share personal info with strangers\n'
                            '• Verify identities before trusting\n'
                            '• Don\'t send photos to unknown people\n'
                            '• If in doubt, block and report',
                            style: TextStyle(
                              color: Colors.white,
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
                          color: DigitalTheme.dangerRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: DigitalTheme.dangerRed),
                        ),
                        child: Text(
                          'THREAT LEVEL: HIGH\nSome choices compromised security. Review protocols and retry.',
                          style: DigitalTheme.bodyStyle.copyWith(
                            color: DigitalTheme.dangerRed,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
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
                          foregroundColor: DigitalTheme.primaryText,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh),
                            const SizedBox(width: 8),
                            Text(
                              'RETRY MISSION',
                              style: DigitalTheme.headingStyle.copyWith(
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
                        backgroundColor: DigitalTheme.primaryCyan,
                        foregroundColor: DigitalTheme.primaryText,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'NEXT LEVEL',
                            style: DigitalTheme.headingStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}