import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter3/screens/level2_intro.dart';
import 'package:claude/games/chapter3/widgets/ProfileCard.dart';
import 'package:claude/games/chapter3/widgets/feedback_panel.dart';
import 'package:claude/games/chapter3/widgets/game_app_bar.dart';
import 'package:claude/games/chapter3/widgets/game_background.dart';
import 'package:claude/games/chapter3/widgets/game_button.dart';
import 'package:claude/games/chapter3/widgets/game_status_bar.dart';
import 'package:claude/games/chapter3/widgets/level_complete_card.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../widgets/theme.dart';


class Level1 extends StatefulWidget {
  const Level1({super.key});

  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> with TickerProviderStateMixin {
  // Game state variables
  int score = 0;
  int currentRound = 0;
  String feedback = ' ';
  bool cardSelected = false;
  bool showRetry = false;
  bool levelCompleted = false;

  final AudioEffectsService _audioEffects = AudioEffectsService();
  
  List<Map<String, dynamic>> gameResults = [];

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // Game data
  final List<Map<String, dynamic>> profileRounds = [
    {
      'fake': {
        'image': 'assets/images/fake1.jpg',
        'username': '@rahul_2_0',
        'bio': 'Original Account ....| | Lets chat 🤙',
      },
      'real': {
        'image': 'assets/images/real3.png',
        'username': 'Rahul Verma',
        'bio': '🎮 Gamer |Learning new things every day!',
      },
    },
    {
      'fake': {
        'image': 'assets/images/f1.png',
        'username': '@divya_menon23',
        'bio': '🐱 Cat | UX @ pixel labs | 💬 DM me 😊',
      },
      'real': {
        'image': 'assets/images/real1.png',
        'username': '@divya.menon',
        'bio': 'Cat mom | ☕ Chai lover | UX Designer @ Pixel Labs',
      },
    },
    {
      'fake': {
        'image': 'assets/images/real2.png',
        'username': 'megha__xoxo',
        'bio': '✨ Life is a party 🎉 | Snap me 👉 @xoxo_megha | 💋💃',
      },
      'real': {
        'image': 'assets/images/real2.png',
        'username': 'megha.joseph',
        'bio': '📸 Photographer | 🐾 Dog lover | Volunteering @GreenIndia 🌱 ',
      },
    },
  ];

  // Game logic methods
  void handleFakeSelection() {
    if (cardSelected || levelCompleted) return;

    setState(() {
      score++;
      feedback = 'PROFILE ANALYSIS COMPLETE';
      cardSelected = true;
      gameResults.add({
          'round': currentRound + 1,
          'isCorrect': true,
          'selectedProfile': 'fake',
      });
      _audioEffects.playCorrect();
    });

    _processNextRound();
  }

  void handleRealSelection() {
    if (cardSelected || levelCompleted) return;

    setState(() {
      feedback = 'DETECTION FAILED - REAL PROFILE';
      cardSelected = true;
      showRetry = true;

      gameResults.add({
        'round': currentRound + 1,
        'isCorrect': false,
        'selectedProfile': 'real',
      });

      _audioEffects.playWrong();
    });
  }

  void _processNextRound() {
    Future.delayed(const Duration(seconds: 2), () {
      if (currentRound >= 2) {
        setState(() {
          levelCompleted = true;
        });

        _showSummaryPage();
        
      } else {
        setState(() {
          currentRound++;
          resetLevel();
        });
      }
    });
  }

  void resetLevel() {
    setState(() {
      feedback = ' ';
      cardSelected = false;
      showRetry = false;
    });

    _audioEffects.stop();
  }

  void _navigateToLevel2() {
    // Pop both Level1 and SummaryPage, then navigate to Level2Intro
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Level2Intro()),
    );
  }

  // Show summary page
  void _showSummaryPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          results: gameResults,
          totalQuestions: 3,
          gameType: GameType.profileDetector, 
          onContinue: _navigateToLevel2,
          isLastGameInChapter: false, // Set to true if this is the last game in chapter
        ),
      ),
    );
  }

  // UI Builder methods
  Widget _buildCyberCard({
    required Widget child,
    Color? borderColor,
    bool isGlowing = false,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: DigitalTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor ?? DigitalTheme.primaryCyan,
              width: 1,
            ),
            boxShadow: isGlowing
                ? [
                    BoxShadow(
                      color: (borderColor ?? DigitalTheme.primaryCyan)
                          .withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : DigitalTheme.cardShadow,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildProfileSelectionArea() {
    if (levelCompleted) return const SizedBox.shrink();
    
    final currentData = profileRounds[currentRound];
    final retryKey = showRetry.toString() + currentRound.toString();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'SELECT THE FAKE PROFILE',
            style: DigitalTheme.subheadingStyle.copyWith(
              color: DigitalTheme.primaryCyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildCyberCard(
                  borderColor: DigitalTheme.dangerRed,
                  isGlowing: !cardSelected,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ProfileCard(
                      key: ValueKey('fake-$retryKey'),
                      image: currentData['fake']['image'],
                      username: currentData['fake']['username'],
                      bio: currentData['fake']['bio'],
                      onSelected: handleFakeSelection,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCyberCard(
                  borderColor: DigitalTheme.successGreen,
                  isGlowing: !cardSelected,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ProfileCard(
                      key: ValueKey('real-$retryKey'),
                      image: currentData['real']['image'],
                      username: currentData['real']['username'],
                      bio: currentData['real']['bio'],
                      onSelected: handleRealSelection,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton() {
    if (!showRetry || levelCompleted) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: GameButton(
        text: 'RETRY ANALYSIS',
        onPressed: resetLevel,
        backgroundColor: DigitalTheme.cardBackground,
        textColor: DigitalTheme.primaryCyan,
        icon: Icons.refresh,
        isIconRight: false,
      ),
    );
  }

  // Widget _buildCompletionCard() {
  //   if (!levelCompleted) return const SizedBox.shrink();
    
  //   return LevelCompletionCard(
  //     title: 'LEVEL COMPLETED',
  //     message: 'Well done! You spotted the imposter and protected your digital identity. Always double-check friend requests and stay vigilant against online clones!',
  //     score: score,
  //     maxScore: 3,
  //     nextButton: GameButton(
  //       text: 'Next Level',
  //       onPressed: () {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const Level2Intro()),
  //         );
  //       },
  //       backgroundColor: Colors.blue,
  //       icon: Icons.arrow_forward,
  //     ),
  //     tips: const [
  //       'Check profile pictures for inconsistencies',
  //       'Look for suspicious usernames and bios',
  //       'Be cautious with unsolicited friend requests',
  //       'Report and block suspicious accounts',
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigitalTheme.darkBackground,
      appBar: const GameAppBar(title: 'CYBER SHIELD - PROFILE DETECTOR'),
      body: GameBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GameStatusBar(
                        levelName: 'Level 1 - Active',
                        score: score,
                        maxScore: 3,
                      ),
                      const SizedBox(height: 20),
                      GameFeedbackPanel(
                        feedback: feedback,
                        isSuccess: score > currentRound,
                        showFeedback: cardSelected,
                        defaultMessage: 'ANALYZING PROFILES...',
                      ),
                      const SizedBox(height: 30),
                      _buildProfileSelectionArea(),
                      const SizedBox(height: 30),
                      _buildRetryButton(),
                      // _buildCompletionCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}