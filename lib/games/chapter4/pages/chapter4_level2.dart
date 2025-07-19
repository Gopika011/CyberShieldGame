import 'package:audioplayers/audioplayers.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';

class GameScenario {
  final String title;
  final String description;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final IconData icon;
  final Color iconColor;

  GameScenario({
    required this.title,
    required this.description,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.icon,
    required this.iconColor,
  });
}

class CredentialDefenderGame extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const CredentialDefenderGame({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  _CredentialDefenderGameState createState() => _CredentialDefenderGameState();
}

class _CredentialDefenderGameState extends State<CredentialDefenderGame> {
  int currentScenarioIndex = 0;
  int score = 0;
  bool hasAnswered = false;
  int? selectedAnswer;
  final soundPlayer = AudioPlayer();
  List<Map<String, dynamic>> gameResults = [];

  final List<GameScenario> scenarios = [
    GameScenario(
      title: "Suspicious Pop-up",
      description: "A pop-up suddenly appears asking for your full debit card number and PIN to 'verify your account security'.",
      options: [
        "A) Enter the details to verify",
        "B) Enter only the PIN, not the card number",
        "C) Close the pop-up immediately"
      ],
      correctAnswerIndex: 2,
      explanation: "Never enter sensitive financial information in unexpected pop-ups. Banks will never ask for your PIN or full card details through pop-ups. Always close suspicious pop-ups and contact your bank directly if concerned.",
      icon: Icons.credit_card,
      iconColor: const Color(0xFF00D4FF),
    ),
    GameScenario(
      title: "OTP Phone Call",
      description: "You receive an OTP SMS. Immediately after, someone calls claiming to be from your bank and asks you to read out the OTP for 'verification purposes'.",
      options: [
        "A) Hang up and enter OTP in your banking app",
        "B) Read the OTP to help them verify",
        "C) Share only the last 3 digits of the OTP"
      ],
      correctAnswerIndex: 0,
      explanation: "Never share OTPs with anyone over the phone. OTPs are meant only for you to enter in legitimate apps/websites. Hang up and use the OTP only in your official banking app.",
      icon: Icons.phone,
      iconColor: const Color(0xFFFF4757),
    ),
    GameScenario(
      title: "Password Sharing",
      description: "Your colleague asks for your work system password because they 'forgot theirs' and need to access something urgently.",
      options: [
        "A) Share your password to help them",
        "B) Share the password but ask them to change it later",
        "C) Refuse and suggest they contact IT support"
      ],
      correctAnswerIndex: 2,
      explanation: "Never share passwords, even with trusted colleagues. Each person should have their own credentials for accountability and security. Direct them to proper IT channels for password reset assistance.",
      icon: Icons.work,
      iconColor: const Color(0xFF00D4FF),
    ),
    GameScenario(
      title: "Email Verification",
      description: "You receive an email from 'support@youbank.com' asking you to click a link and enter your login credentials to 'update your security settings'.",
      options: [
        "A) Click the link and update your settings",
        "B) Delete the email and log in through the official website",
        "C) Forward the email to friends to warn them"
      ],
      correctAnswerIndex: 1,
      explanation: "This is likely a phishing email. Never click links in suspicious emails. Always access your bank through the official website or app directly.",
      icon: Icons.email,
      iconColor: const Color(0xFF00FFE0),
    ),
    GameScenario(
      title: "Public WiFi Banking",
      description: "You're at a coffee shop and need to check your bank balance. The free WiFi 'CoffeeShop_Free' is available.",
      options: [
        "A) Connect to WiFi and check your balance",
        "B) Use your mobile data instead",
        "C) Ask the staff for the WiFi password first"
      ],
      correctAnswerIndex: 1,
      explanation: "Never access sensitive accounts on public WiFi. Public networks are not secure and can be monitored by attackers. Use your mobile data or a trusted VPN for banking activities.",
      icon: Icons.wifi,
      iconColor: const Color(0xFF00FF88),
    ),
    GameScenario(
      title: "Social Media Quiz",
      description: "A fun quiz on social media asks: 'What was your first pet's name?' and 'What street did you grow up on?' to generate your 'superhero name'.",
      options: [
        "A) Skip the quiz entirely",
        "B) Participate - it's just for fun!",
        "C) Use fake answers for the quiz"
      ],
      correctAnswerIndex: 0,
      explanation: "These questions are common security questions used for password recovery. Sharing real answers publicly can help attackers gain access to your accounts. It's safer to avoid such quizzes entirely.",
      icon: Icons.quiz,
      iconColor: const Color(0xFFFF4757),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    soundPlayer.dispose();
    super.dispose();
  }

  void _playSoundEffect(String soundPath) async {
    try {
      await soundPlayer.play(AssetSource(soundPath));
      // await soundPlayer.play(UrlSource(soundPath));
    } catch (e) {
      print("Error playing sound effect: $e");
    }
  }

  void _selectAnswer(int index) {
    if (hasAnswered) return;

    setState(() {
      selectedAnswer = index;
      hasAnswered = true;
    });

    bool isCorrect = index == scenarios[currentScenarioIndex].correctAnswerIndex;
    gameResults.add({
      'questionIndex': currentScenarioIndex,
      'selectedAnswer': index,
      'correctAnswer': scenarios[currentScenarioIndex].correctAnswerIndex,
      'isCorrect': isCorrect,
      'isTimeout': false,
      'question': scenarios[currentScenarioIndex].title,
      'explanation': scenarios[currentScenarioIndex].explanation,
    });

    if (isCorrect) {
      setState(() {
        score++;
      });
      print("hh");
      _playSoundEffect('audio/correct_chime.mp3');
    } else {
      _playSoundEffect('audio/wrong_buzz_short.mp3');
    }
  }

  void _nextScenario() {
    if (currentScenarioIndex < scenarios.length - 1) {
      setState(() {
        currentScenarioIndex++;
        hasAnswered = false;
        selectedAnswer = null;
      });
    } else {
      _navigateToSummary();
    }
  }

void _navigateToSummary() {
  Navigator.pushReplacement( 
    context,
    MaterialPageRoute(
      builder: (context) => SummaryPage( 
        results: gameResults,
        totalQuestions: scenarios.length,
        gameType: GameType.socialEngineering,
        onContinue: null,
        isLastGameInChapter: true,
      ),
    ),
  ).then((result) {
    if (result == 'chapter_complete') {
      // Mark chapter as complete
      GameState().completeChapter(4);
      // Call completion callback
      widget.onGameComplete?.call();
    }
  });
}

  Color _getOptionColor(int index) {
    if (!hasAnswered) return const Color(0x05FFFFFF);
    
    if (index == scenarios[currentScenarioIndex].correctAnswerIndex) {
      return const Color(0xFF00FF88).withOpacity(0.1);
    } else if (index == selectedAnswer) {
      return const Color(0xFFFF4757).withOpacity(0.1);
    }
    return const Color(0x05FFFFFF);
  }

  Color _getOptionBorderColor(int index) {
    if (!hasAnswered) return const Color(0xFF00D4FF).withOpacity(0.3);
    
    if (index == scenarios[currentScenarioIndex].correctAnswerIndex) {
      return const Color(0xFF00FF88);
    } else if (index == selectedAnswer) {
      return const Color(0xFFFF4757);
    }
    return const Color(0xFF00D4FF).withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    final scenario = scenarios[currentScenarioIndex];
    
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
                            'Question ${currentScenarioIndex + 1} of ${scenarios.length}',
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
                        value: (currentScenarioIndex + 1) / scenarios.length,
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
                              border: Border.all(color: scenario.iconColor.withOpacity(0.5), width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: scenario.iconColor.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: scenario.iconColor, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: scenario.iconColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    scenario.icon,
                                    color: scenario.iconColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'THREAT DETECTED',
                                        style: TextStyle(
                                          color: Color(0xFF00D4FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        scenario.title.toUpperCase(),
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
                          
                          // Description
                          Text(
                            scenario.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB8C6DB),
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Options
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (int i = 0; i < scenario.options.length; i++)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _selectAnswer(i),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: _getOptionColor(i),
                                              border: Border.all(
                                                color: _getOptionBorderColor(i),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                if (hasAnswered && i == scenarios[currentScenarioIndex].correctAnswerIndex)
                                                  const Icon(Icons.check_circle, color: Color(0xFF00FF88), size: 20),
                                                if (hasAnswered && i == selectedAnswer && i != scenarios[currentScenarioIndex].correctAnswerIndex)
                                                  const Icon(Icons.cancel, color: Color(0xFFFF4757), size: 20),
                                                if (hasAnswered)
                                                  const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    scenario.options[i],
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
                          
                          // Explanation
                          if (hasAnswered)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
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
                                        "INTEL BRIEFING",
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
                                  Text(
                                    scenario.explanation,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFB8C6DB),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Next button
                if (hasAnswered)
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextScenario,
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
                        currentScenarioIndex < scenarios.length - 1 ? 'NEXT THREAT' : 'MISSION COMPLETE',
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
}