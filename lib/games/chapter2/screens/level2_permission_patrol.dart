import 'package:claude/components/game_progress_bar.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter2/screens/level3_wifi_woes.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../widgets/cyber_button.dart';

class Level2PermissionPatrol extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Level2PermissionPatrol({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  _Level2PermissionPatrolState createState() => _Level2PermissionPatrolState();
}

class _Level2PermissionPatrolState extends State<Level2PermissionPatrol>
    with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  int lives = 3;
  bool showResult = false;
  String resultMessage = '';
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  List<Map<String, dynamic>> results = [];
  
  // Harder permission scenarios with tricky apps
  final List<Map<String, dynamic>> permissionScenarios = [
    // {
    //   'appName': 'FlashLight Pro',
    //   'appIcon': Icons.flashlight_on,
    //   'appType': 'Utility',
    //   'rating': '4.8★ (2.1M reviews)',
    //   'permissions': [
    //     {'name': 'Camera', 'icon': Icons.camera_alt, 'suspicious': false, 'reason': 'Needed for flashlight function'},
    //     {'name': 'Location (Precise)', 'icon': Icons.location_on, 'suspicious': true, 'reason': 'Why does flashlight need your exact location?'},
    //     {'name': 'Contacts', 'icon': Icons.contacts, 'suspicious': true, 'reason': 'Flashlight should NOT need your contacts!'},
    //     {'name': 'Microphone', 'icon': Icons.mic, 'suspicious': true, 'reason': 'No reason for flashlight to access microphone'},
    //   ],
    //   'correctChoice': 'deny',
    //   'explanation': 'DENY! This flashlight app asks for way too many permissions. Camera is okay, but Location, Contacts, and Microphone are major red flags!'
    // },
    {
      'appName': 'Photo Editor Studio',
      'appIcon': Icons.photo,
      'appType': 'Photography',
      'rating': '4.2★ (890K reviews)',
      'permissions': [
        {'name': 'Photos/Media', 'icon': Icons.photo_library, 'suspicious': false, 'reason': 'Obviously needed to edit photos'},
        {'name': 'Camera', 'icon': Icons.camera_alt, 'suspicious': false, 'reason': 'To take new photos for editing'},
        {'name': 'Storage', 'icon': Icons.storage, 'suspicious': false, 'reason': 'To save edited photos'},
      ],
      'correctChoice': 'allow',
      'explanation': 'ALLOW! All permissions make perfect sense for a photo editing app. No suspicious requests here.'
    },
    // {
    //   'appName': 'Super Fun Games',
    //   'appIcon': Icons.games,
    //   'appType': 'Games',
    //   'rating': '3.9★ (156K reviews)',
    //   'permissions': [
    //     {'name': 'Phone Calls', 'icon': Icons.phone, 'suspicious': true, 'reason': 'Games should NOT make phone calls!'},
    //     {'name': 'SMS Messages', 'icon': Icons.message, 'suspicious': true, 'reason': 'Why would a game send text messages?'},
    //     {'name': 'Location (Background)', 'icon': Icons.location_on, 'suspicious': true, 'reason': 'Constant location tracking is suspicious'},
    //     {'name': 'Install Unknown Apps', 'icon': Icons.download, 'suspicious': true, 'reason': 'HUGE red flag - can install malware!'},
    //   ],
    //   'correctChoice': 'deny',
    //   'explanation': 'DENY IMMEDIATELY! This is clearly malware. No legitimate game needs to make calls, send SMS, or install other apps!'
    // },
    {
      'appName': 'Banking Assistant',
      'appIcon': Icons.account_balance,
      'appType': 'Finance',
      'rating': '4.9★ (50 reviews)', // Low review count is suspicious
      'permissions': [
        {'name': 'Device Admin Rights', 'icon': Icons.admin_panel_settings, 'suspicious': true, 'reason': 'Can control your entire device!'},
        {'name': 'All Files Access', 'icon': Icons.folder, 'suspicious': true, 'reason': 'Access to ALL your files is dangerous'},
        {'name': 'Accessibility Services', 'icon': Icons.accessibility, 'suspicious': true, 'reason': 'Can read and control everything on screen'},
        {'name': 'Camera', 'icon': Icons.camera_alt, 'suspicious': false, 'reason': 'Might be for check deposits'},
      ],
      'correctChoice': 'deny',
      'explanation': 'DENY! Fake banking app with dangerous permissions. Real banks never ask for Device Admin or Accessibility rights!'
    },
    {
      'appName': 'COVID Tracker Official',
      'appIcon': Icons.coronavirus,
      'appType': 'Health',
      'rating': '4.1★ (2.8M reviews)',
      'permissions': [
        {'name': 'Location', 'icon': Icons.location_on, 'suspicious': false, 'reason': 'For contact tracing'},
        {'name': 'Bluetooth', 'icon': Icons.bluetooth, 'suspicious': false, 'reason': 'For proximity detection'},
        {'name': 'Internet', 'icon': Icons.wifi, 'suspicious': false, 'reason': 'To upload anonymous data'},
        {'name': 'All Contacts', 'icon': Icons.contacts, 'suspicious': true, 'reason': 'Should only need exposure notifications, not full contact list'},
      ],
      'correctChoice': 'deny',
      'explanation': 'TRICKY! While some permissions are okay, asking for ALL contacts is suspicious. Real COVID apps use anonymous Bluetooth tokens.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    
    // Shuffle scenarios for variety
    permissionScenarios.shuffle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void selectOption(String choice) {
    bool isCorrect = choice == permissionScenarios[currentQuestion]['correctChoice'];
    results.add({
      'questionIndex': currentQuestion,
      'userAnswer': choice,
      'correctAnswer': permissionScenarios[currentQuestion]['isFake'],
      'isCorrect': isCorrect,
      'website': permissionScenarios[currentQuestion],
    });

    setState(() {
      showResult = true;
      if (isCorrect) {
        score += 1; 
        resultMessage = permissionScenarios[currentQuestion]['explanation'];
        _audioEffects.playCorrect();
      } else {
        lives--;
        _shakeController.forward().then((_) => _shakeController.reverse());
        resultMessage = permissionScenarios[currentQuestion]['explanation'];
        _audioEffects.playWrong();
        
      }
    });
  }

  void nextQuestion() {    
    if (currentQuestion < permissionScenarios.length - 1) {
      setState(() {
        currentQuestion++;
        showResult = false;
      });
    } else {
      setState(() {
        levelCompleted = true;
      });
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
          totalQuestions: permissionScenarios.length, 
          gameType: GameType.appPermissions, 
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
    // Navigate to instruction page for Level3WifiWoes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InstructionPage(
          gameType: GameType.networkRisk, 
          nextGameWidget: Level3WifiWoes(
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
          // Main content with shake animation
          SafeArea(
            child: Column(
              children: [
                // Progress indicator
                GameProgressBar(
                  currentQuestion: currentQuestion,
                  totalQuestions: permissionScenarios.length,
                ),
                
                Expanded(
                  child: showResult ? _buildResultScreen() : _buildGameScreen(),
                ),
              ],)
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    final scenario = permissionScenarios[currentQuestion];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // App permission request mockup
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFAA00), width: 2),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF1A2A3A).withOpacity(0.8),
              ),
              child: Column(
                children: [
                  // App header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3A4A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF00D4FF)),
                          ),
                          child: Icon(
                            scenario['appIcon'],
                            color: const Color(0xFF00D4FF),
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scenario['appName'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${scenario['appType']} • ${scenario['rating']}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Permission request
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: const Color(0xFFFFAA00),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'App wants these permissions:',
                                style: TextStyle(
                                  color: const Color(0xFFFFAA00),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Permission list
                          Expanded(
                            child: ListView.builder(
                              itemCount: scenario['permissions'].length,
                              itemBuilder: (context, index) {
                                final permission = scenario['permissions'][index];
                                
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.5)
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        permission['icon'],
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              permission['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // if (isSuspicious) ...[
                                            //   SizedBox(height: 4),
                                            //   Text(
                                            //     '⚠️ ${permission['reason']}',
                                            //     style: TextStyle(
                                            //       color: Colors.red,
                                            //       fontSize: 12,
                                            //     ),
                                            //   ),
                                            // ],
                                          ],
                                        ),
                                      ),
                                      // if (isSuspicious)
                                      //   Icon(
                                      //     Icons.dangerous,
                                      //     color: Colors.red,
                                      //     size: 20,
                                      //   ),
                                    ],
                                  ),
                                );
                              },
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
          //   'Should you ALLOW or DENY these permissions?',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18,
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
                  text: 'ALLOW',
                  color: const Color(0xFF00FF88),
                  onPressed: () => selectOption('allow'),
                  isLarge: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CyberButton(
                  text: 'DENY',
                  color: const Color(0xFFFF4444),
                  onPressed: () => selectOption('deny'),
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
          // _buildHeader(),
          // SizedBox(height: 40),
          
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
                      text: currentQuestion < permissionScenarios.length - 1 
                          ? 'NEXT APP' 
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

  // Widget _buildHeader() {
  //   return Row(
  //     children: [
  //       IconButton(
  //         icon: Icon(Icons.arrow_back, color: const Color(0xFF00D4FF)),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //       Expanded(
  //         child: Column(
  //           children: [
  //             Text(
  //               'LEVEL 2: PERMISSION PATROL',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Text(
  //               'App ${currentQuestion + 1} of ${permissionScenarios.length}',
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}