import 'package:claude/enums/games.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/services/audio_effects.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';
import '../widgets/cyber_button.dart';

class Level3WifiWoes extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Level3WifiWoes({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  _Level3WifiWoesState createState() => _Level3WifiWoesState();
}

class _Level3WifiWoesState extends State<Level3WifiWoes> {
  int score = 0;
  int currentStep = 0;
  bool showResult = false;
  String resultMessage = "";
  bool isCorrect = false;
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();

  List<Map<String, dynamic>> results = [];

  final List<Map<String, dynamic>> scenarios = [
    {
      'title': 'Free Public Wi-Fi',
      'description': 'You\'re at a coffee shop and want to buy the iPhone. You see "Free_WiFi_Shop" network.',
      'question': 'Should you connect and enter your card details?',
      'options': ['Use Mobile Data Instead', 'Connect & Shop Now'],
      'correctAnswer': 1,
      'explanation': 'Public Wi-Fi is unsafe for payments! Always use mobile data or trusted networks for shopping.',
    },
    {
      'title': 'Airport WiFi Payment',
      'description': 'At airport, connected to "Airport_Free_WiFi". The deal expires in 10 minutes!',
      'question': 'Quick! Should you enter card details now?',
      'options': ['Enter Card Details Now', 'Wait for Secure Connection'],
      'correctAnswer': 1,
      'explanation': 'Never rush payments on public WiFi! Scammers create urgency. Use secure networks only.',
    },
    {
      'title': 'Hotel WiFi Dilemma',
      'description': 'Hotel WiFi asks for room number and surname for "verification" before shopping.',
      'question': 'This seems secure. Should you proceed?',
      'options': ['Proceed with Payment', 'Verify with Hotel First'],
      'correctAnswer': 1,
      'explanation': 'Fake hotel portals collect personal info! Always verify with hotel staff before entering details.',
    },
    // {
    //   'title': 'VPN Protection',
    //   'description': 'You have a VPN app on your phone. Should you use it before shopping on public WiFi?',
    //   'question': 'Will VPN make public WiFi shopping safe?',
    //   'options': ['Yes, VPN Makes It Safe', 'Still Better to Avoid'],
    //   'correctAnswer': 1,
    //   'explanation': 'VPN helps but isn\'t foolproof! Best practice: avoid payments on public WiFi entirely.',
    //   'points': 100,
    // },
    // {
    //   'title': 'Final Decision',
    //   'description': 'After learning about WiFi risks, Arya sees the same iPhone deal at home on secure WiFi.',
    //   'question': 'Now what should she do?',
    //   'options': ['Buy Immediately', 'Research the Website First'],
    //   'correctAnswer': 1,
    //   'explanation': 'Great! Even on secure WiFi, always verify if the website/deal is legitimate first!',
    //   'points': 100,
    // },
  ];


  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      currentStep = 0;
      score = 0;
      showResult = false;
      levelCompleted = false;
      resultMessage = '';
      results.clear();
    });
  }
  void handleAnswer(int selectedAnswer) {
    bool isAnswerCorrect = selectedAnswer == scenarios[currentStep]['correctAnswer'];

    results.add({
      'questionIndex': currentStep,
      'userAnswer': selectedAnswer,
      'correctAnswer': scenarios[currentStep]['correctAnswer'],
      'isCorrect': isAnswerCorrect,
      'scenario': scenarios[currentStep],
    });

    setState(() {
      isCorrect = isAnswerCorrect;
      
      if (isCorrect) {
        score += 1;
        resultMessage = "Correct! " + scenarios[currentStep]['explanation'];
        _audioEffects.playCorrect();
      } else {
        resultMessage = "Wrong! " + scenarios[currentStep]['explanation'];
        _audioEffects.playWrong();
      }
      
      showResult = true;
    });
  }

  void nextStep() {
    setState(() {
      if (currentStep < scenarios.length - 1) {
        currentStep++;
        showResult = false;
        resultMessage = "";
      } else {
        // Level completed
        GameState().completeChapter(2);
        setState(() {
          levelCompleted = true;
        });
        _navigateToSummary();
      }
    });
  }

  void _navigateToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          results: results,
          totalQuestions: scenarios.length,
          gameType: GameType.networkRisk, 
          onContinue: _onSummaryContinue,
          isLastGameInChapter: true, 
          onRetry: () {
            // Pop summary page
            Navigator.pop(context);
            _retryLevel();
          },
        ),
      ),
    );
  }

  void _retryLevel() {
    setState(() {
      currentStep = 0;
      score = 0;
      showResult = false;
      levelCompleted = false;
      resultMessage = '';
      results.clear();
    });

    _audioEffects.stop();
  }

  void _onSummaryContinue() {
    GameState().completeChapter(2);
    // Pop both summary page and game page
    Navigator.of(context).pop(); // Pop summary page
    Navigator.of(context).popUntil((route) => route.settings.name == '/chapters');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0A1A2A),
                  const Color(0xFF1A2A3A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Grid background painter
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context, score),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Text(
                        'LEVEL 3: WI-FI WOES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'App ${currentStep + 1} of ${scenarios.length}',
                        style: TextStyle(
                          color: const Color(0xFF00D4FF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Lives and Score
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: List.generate(3, (index) => 
                  //         Icon(
                  //           Icons.favorite,
                  //           color: index < lives ? Colors.red : Colors.grey,
                  //           size: 24,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: const Color(0xFF00D4FF)),
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //       child: Text(
                  //         'Score: $score',
                  //         style: TextStyle(
                  //           color: const Color(0xFF00D4FF),
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  
                  SizedBox(height: 40),
                  
                  if (!showResult) ...[
                    // Scenario Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFAA00), width: 2),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFAA00).withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // WiFi Icon
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFAA00).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.wifi,
                              color: const Color(0xFFFFAA00),
                              size: 40,
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          Text(
                            scenarios[currentStep]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: 16),
                          
                          Text(
                            scenarios[currentStep]['description'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: 20),
                          
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              scenarios[currentStep]['question'],
                              style: TextStyle(
                                color: const Color(0xFF00D4FF),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Answer Buttons
                    Column(
                      children: List.generate(
                        scenarios[currentStep]['options'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => handleAnswer(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                scenarios[currentStep]['options'][index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Result Screen - Centered
                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isCorrect ? Colors.green : Colors.red,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 64,
                              ),
                              
                              SizedBox(height: 16),
                              
                              Text(
                                isCorrect ? 'Correct!' : 'Wrong!',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                              SizedBox(height: 16),
                              
                              Text(
                                resultMessage,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: 32),
                              
                              CyberButton(
                                text: currentStep < scenarios.length - 1 ? 'NEXT' : 'FINISH',
                                onPressed: nextStep,
                                isLarge: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}