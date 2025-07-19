import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter2/screens/level2_permission_patrol.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:claude/pages/summary_page.dart';
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
        score += 100;
        resultMessage = '✅ CORRECT!\n\n${websites[currentQuestion]['explanation']}';
      } else {
        resultMessage = '❌ WRONG!\n\n${websites[currentQuestion]['explanation']}';
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
      // Game completed
      _navigateToSummary();
      // Navigator.pop(context, score);
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
        ),
      ),
    );
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
      body: Container(
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
        child: SafeArea(
          child: showResult ? _buildResultScreen() : _buildGameScreen(),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    final website = websites[currentQuestion];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          SizedBox(height: 20),
          
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
          
          // Question
          Text(
            'Is this website SAFE or FAKE?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
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
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00D4FF), width: 2),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1A2A3A).withOpacity(0.8),
            ),
            child: Column(
              children: [
                Text(
                  resultMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 24),
                
                Text(
                  'Score: $score',
                  style: TextStyle(
                    color: const Color(0xFF00D4FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 24),
                
                CyberButton(
                  text: currentQuestion < websites.length - 1 ? 'NEXT WEBSITE' : 'COMPLETE LEVEL',
                  onPressed: nextQuestion,
                  isLarge: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF00D4FF)),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'LEVEL 1: SHOP OR STOP?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Question ${currentQuestion + 1} of ${websites.length}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00D4FF)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Score: $score',
            style: TextStyle(
              color: const Color(0xFF00D4FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}