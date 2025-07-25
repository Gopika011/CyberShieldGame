import 'package:claude/components/game_progress_bar.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter2/screens/level2_permission_patrol.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../widgets/cyber_button.dart';

class Level1ShopOrStop extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Level1ShopOrStop({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  _Level1ShopOrStopState createState() => _Level1ShopOrStopState();
}

class _Level1ShopOrStopState extends State<Level1ShopOrStop> {
  int currentQuestion = 0;
  int score = 0;
  bool showResult = false;
  String resultMessage = '';
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();

  List<Map<String, dynamic>> results = [];
  
  // Fake website scenarios
  final List<Map<String, dynamic>> websites = [
    {
      'title': 'SUPER DEALS ELECTRONICS',
      'url': 'www.elektornics-deals.com',
      'price': '₹5,999',
      'originalPrice': '₹89,999',
      'discount': '93% OFF',
      'features': [
        'iPhone 15 Pro Max',
        'Limited Time Offer!',
        'Only 2 left in stock!',
        'Free delivery in 1 hour'
      ],
      'redFlags': [
        'Spelling mistake in URL',
        'Unrealistic discount',
        'Pressure tactics',
        'Too good to be true price'
      ],
      'isFake': true,
      'explanation': 'This is FAKE! Red flags: Misspelled URL, unrealistic 93% discount, and pressure tactics.'
    },
    {
      'title': 'AMAZON INDIA',
      'url': 'www.amazon.in',
      'price': '₹79,999',
      'originalPrice': '₹89,999',
      'discount': '11% OFF',
      'features': [
        'iPhone 15 Pro Max',
        'Fulfilled by Amazon',
        'Prime delivery',
        '1 year warranty'
      ],
      'redFlags': [],
      'isFake': false,
      'explanation': 'This is SAFE! Legitimate website with reasonable discount and proper URL.'
    },
    {
      'title': 'MOBILE ZONE OFFERS',
      'url': 'www.mobilezone-offer.tk',
      'price': '₹9,999',
      'originalPrice': '₹89,999',
      'discount': '89% OFF',
      'features': [
        'iPhone 15 Pro Max',
        'Cash on Delivery',
        'No questions asked return',
        'Hurry! Sale ends in 10 minutes'
      ],
      'redFlags': [
        'Suspicious .tk domain',
        'Unrealistic discount',
        'Countdown pressure',
        'Vague return policy'
      ],
      'isFake': true,
      'explanation': 'This is FAKE! Red flags: Suspicious domain, unrealistic discount, and countdown pressure.'
    }
  ];

  void selectOption(bool userThinksFake) {
    bool isCorrect = userThinksFake == websites[currentQuestion]['isFake'];
    results.add({
      'questionIndex': currentQuestion,
      'userAnswer': userThinksFake,
      'correctAnswer': websites[currentQuestion]['isFake'],
      'isCorrect': isCorrect,
      'website': websites[currentQuestion],
    });
    setState(() {
      showResult = true;
      if (isCorrect) {
        score += 1;
        resultMessage = websites[currentQuestion]['explanation'];
        _audioEffects.playCorrect();
      } else {
        resultMessage = websites[currentQuestion]['explanation'];
        _audioEffects.playWrong();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < websites.length - 1) {
      setState(() {
        currentQuestion++;
        showResult = false;
      });
    } else {
      setState(() {
        levelCompleted = true;
      });
      _navigateToSummary();
    }
  }

  void _navigateToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          results: results,
          totalQuestions: websites.length,
          gameType: GameType.ecommerceScam, 
          onContinue: _navigateToNextGame,
          isLastGameInChapter: false, 
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
      currentQuestion = 0;
      score = 0;
      showResult = false;
      levelCompleted = false;
      resultMessage = '';
      results.clear();
    });

    _audioEffects.stop();
  }

  void _navigateToNextGame() {
    // Navigate to instruction page for Level2PermissionPatrol
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InstructionPage(
          gameType: GameType.appPermissions, 
          nextGameWidget: Level2PermissionPatrol(
            onGameComplete: widget.onGameComplete,
            onGameExit: widget.onGameExit,
          ),
          onExitChapter: widget.onGameExit,
        ),
      ),
    );
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
                  Color.fromARGB(202, 10, 21, 32),
                  Color.fromARGB(206, 15, 27, 46),
                  Color.fromARGB(158, 26, 35, 50),
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
            child: Column(
              children: [
                // Progress indicator
                GameProgressBar(
                  currentQuestion: currentQuestion,
                  totalQuestions: websites.length,
                ),
                
                Expanded(
                  child: showResult ? _buildResultScreen() : _buildGameScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    final website = websites[currentQuestion];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Website mockup
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF1A2A3A).withOpacity(0.5),
              ),
              child: Column(
                children: [
                  // Browser bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3A4A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.language, color: Colors.white70, size: 20),
                        SizedBox(width: 8),
                        Text(
                          website['url'],
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  // Website content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            website['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Product card
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...website['features'].map<Widget>((feature) => 
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      '• $feature',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  )
                                ).toList(),
                                
                                SizedBox(height: 16),
                                
                                Row(
                                  children: [
                                    Text(
                                      website['price'],
                                      style: TextStyle(
                                        color: const Color(0xFF00FF88),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      website['originalPrice'],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 8),
                                
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    website['discount'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // // Question
          // Text(
          //   'Is this website SAFE or FAKE?',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          
          SizedBox(height: 20),
          
          // Answer buttons
          Row(
            children: [
              Expanded(
                child: CyberButton(
                  text: 'SAFE TO SHOP',
                  color: const Color(0xFF00FF88),
                  onPressed: () => selectOption(false),
                  isLarge: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CyberButton(
                  text: 'FAKE - AVOID!',
                  color: const Color(0xFFFF4444),
                  onPressed: () => selectOption(true),
                  isLarge: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

Widget _buildResultScreen() {
  bool isCorrect = results.isNotEmpty ? results.last['isCorrect'] : false;
  
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
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
                    text: currentQuestion < websites.length - 1 
                        ? 'NEXT WEBSITE' 
                        : 'COMPLETE LEVEL',
                    onPressed: nextQuestion,
                    isLarge: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}