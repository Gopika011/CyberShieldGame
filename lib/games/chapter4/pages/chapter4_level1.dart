import 'package:audioplayers/audioplayers.dart';
import 'package:claude/components/feedback_overlay.dart';
import 'package:claude/enums/feedback_effect.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter4/components/chapter4_Content.dart';
import 'package:claude/games/chapter4/components/chapter4_fbutton.dart';
import 'package:claude/games/chapter4/components/chapter4_load.dart';
import 'package:claude/games/chapter4/pages/chapter4_level2.dart';
import 'package:claude/pages/land.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:flutter/material.dart';


class Chapter4MainPage extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Chapter4MainPage({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  State<Chapter4MainPage> createState() => _Chapter4MainPageState();
}

class _Chapter4MainPageState extends State<Chapter4MainPage> with SingleTickerProviderStateMixin {
  final questions = [
    {
      'audio': 'audio/call1.mp3',
      'transcript': 'Hello, this is from your bank. Your account will be suspended immediately unless you confirm your account details and OTP.',
      'isLegit': false,
    },
    {
      'audio': 'audio/call2.mp3',
      'transcript': 'Hello, this is Rohit speaking from your bank. You have been selected for a special cashback offer. Please share your UPI PIN to activate the offer.',
      'isLegit': false,
    },
    {
      'audio': 'audio/audio1.mp3',
      'transcript': 'Hello, this is from your bank. ',
      'isLegit': false,
    },
  ];

  int currentIndex = 0; 
  bool _hasAnswered = false; 
  bool _audioComplete = false; 
  String feedback = ''; 
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer soundPlayer = AudioPlayer(); 

  late AnimationController _progressController; 
  late Animation<double> _progressBarAnimation; 
  List<Map<String, dynamic>> results = [];

  FeedbackEffect _currentFeedbackEffect = FeedbackEffect.none; 

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Duration for progress bar to fill
    );

    _progressBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {}); // Redraw the UI on animation tick

        // Check if progress is complete and user hasn't answered (timeout)
        if (_progressBarAnimation.value >= 0.99 && !_hasAnswered) {
          print("Progress complete - triggering timeout");
          _handleCheck(!(questions[currentIndex]['isLegit'] as bool), isTimeout: true);
        }
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    soundPlayer.dispose();
    player.dispose();
    super.dispose();
  }

  void _playSoundEffect(String soundPath) async {
    try {
      await soundPlayer.play(AssetSource('assets/games/chapter4/$soundPath'));
    } catch (e) {
      print("Error playing sound effect: $e");
    }
  }

  void _playSound() async {
    String audioPath = questions[currentIndex]['audio'] as String;
    try {
      await player.play(AssetSource('$audioPath'));

      player.onPlayerComplete.listen((event) {
        setState(() {
          _audioComplete = true; 
        });
        _progressController.forward(); 
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _handleCheck(bool check, {bool isTimeout = false}) {
    if (_hasAnswered) return; 
    _hasAnswered = true;
    print("User chose: $check");

    bool correct = (check == questions[currentIndex]['isLegit']);

    results.add({
      'questionIndex': currentIndex,
      'userAnswer': check,
      'correctAnswer': questions[currentIndex]['isLegit'],
      'isCorrect': correct,
      'isTimeout': isTimeout,
      'transcript': questions[currentIndex]['transcript'],
    });

    setState(() {
      if (isTimeout) {
        _currentFeedbackEffect = FeedbackEffect.timeout;
        _playSoundEffect('audio/wrong_buzz_short.mp3');
      } else if (correct) {
        feedback = 'CORRECT';
        _currentFeedbackEffect = FeedbackEffect.correct;
        _playSoundEffect('audio/correct_chime.mp3');
      } else {
        feedback = 'WRONG';
        _currentFeedbackEffect = FeedbackEffect.wrong;
        _playSoundEffect('audio/wrong_buzz_short.mp3');
      }
      _progressController.stop(); 
    });
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _currentFeedbackEffect = FeedbackEffect.none; 
        if (currentIndex < questions.length - 1) {
          currentIndex++;
          _hasAnswered = false;
          _progressController.value = 0.0; 
          _audioComplete = false; 
          player.stop(); 
        } else {
          _navigateToSummary();
        }
      });
    });
  }

  /// Navigates to the summary page of the game.
  void _navigateToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage( 
          results: results,
          totalQuestions: questions.length,
          gameType: GameType.spamCall,
          onContinue: _navigateToNextGame,
          isLastGameInChapter: false,
        ),
      ),
    );
  }

  /// Navigates to the next game in the chapter or signals chapter completion.
  void _navigateToNextGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CredentialDefenderGame(
          onGameComplete: widget.onGameComplete,
          onGameExit: widget.onGameExit,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.9;
    final double maxCardWidth = 400;

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

          // Grid background painter
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter( // Using Chapter4GridPainter
                gridColor: const Color(0x1A00D4FF),
                cellSize: 25,
              ),
            ),
          ),

          // Progress indicator header
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea( // Use SafeArea to avoid status bar overlap
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use min to wrap content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${currentIndex + 1} of ${questions.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        // Optional: Add an exit button
                        IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.grey[600]),
                          onPressed: () {
                            player.stop(); // Stop audio before exiting
                            soundPlayer.stop();
                            widget.onGameExit?.call(); // Call exit callback
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (currentIndex + 1) / questions.length,
                      backgroundColor: Colors.grey[700],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content area
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Content card displaying transcript
                  Chapter4ContentCard( // Using Chapter4ContentCard
                    contentText: questions[currentIndex]['transcript'] as String,
                    screenWidth: screenWidth,
                    feedbackEffect: _currentFeedbackEffect,
                  ),

                  const SizedBox(height: 32),
                  // Load bar / progress animation
                  Chapter4LoadBar( // Using Chapter4LoadBar
                    animation: _progressBarAnimation,
                    cardWidth: cardWidth,
                    maxCardWidth: maxCardWidth,
                  ),

                  const SizedBox(height: 62),

                  // Animated switcher for PLAY/ACCEPT/REJECT buttons
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _audioComplete
                        ? SizedBox(
                            key: ValueKey('buttons'), // Key for AnimatedSwitcher
                            width: maxCardWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Chapter4Fbutton(label: "ACCEPT", onPressed: () => _handleCheck(true), isAccept: true), // Using Chapter4Fbutton
                                const SizedBox(width: 20),
                                Chapter4Fbutton(label: "REJECT", onPressed: () => _handleCheck(false), isAccept: false) // Using Chapter4Fbutton
                              ],
                            ),
                          )
                        : SizedBox(
                            key: ValueKey('play_button'), // Key for AnimatedSwitcher
                            width: maxCardWidth,
                            child: Chapter4Fbutton(label: "PLAY", onPressed: _playSound, isAccept: true), // Using Chapter4Fbutton
                          ),
                  )
                ],
              ),
            ),
          ),
          // Feedback overlay for visual effects (correct/wrong/timeout)
          FeedbackOverlay(currentFeedbackEffect: _currentFeedbackEffect), // Using Chapter4FeedbackOverlay
        ],
      ),
    );
  }
}