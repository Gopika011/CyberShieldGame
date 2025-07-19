import '../widgets/ProfileCard.dart';
import 'package:flutter/material.dart';
import 'level2_intro.dart';
import '../widgets/theme.dart';
import '../chapter3.dart';
import 'package:provider/provider.dart';

class Level1 extends StatefulWidget {
  const Level1({super.key});

  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> with TickerProviderStateMixin {
  int score = 0;
  int currentRound = 0;
  String feedback = ' ';
  bool cardSelected = false;
  bool showRetry = false;
  bool levelCompleted = false;
  
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
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

  void handleFakeSelection() {
    if (cardSelected || levelCompleted) return;

    setState(() {
      score++;
      feedback = 'PROFILE ANALYSIS COMPLETE';
      cardSelected = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentRound >= 2) {
        setState(() {
          levelCompleted = true;
        });
      } else {
        setState(() {
          currentRound++;
          resetLevel();
        });
      }
    });
  }

  void handleRealSelection() {
    if (cardSelected || levelCompleted) return;

    setState(() {
      feedback = 'DETECTION FAILED - REAL PROFILE';
      cardSelected = true;
      showRetry = true;
    });
  }

  void resetLevel() {
    setState(() {
      feedback = ' ';
      cardSelected = false;
      showRetry = false;
    });
  }

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
                'Level 1 - Active',
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
                '$score/3',
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DigitalTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cardSelected 
              ? (score > currentRound ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
              : DigitalTheme.primaryCyan,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: cardSelected
                    ? (score > currentRound ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                    : DigitalTheme.primaryCyan,
                width: 2,
              ),
              color: cardSelected
                  ? (score > currentRound ? DigitalTheme.successGreen.withOpacity(0.15) : DigitalTheme.dangerRed.withOpacity(0.15))
                  : DigitalTheme.primaryCyan.withOpacity(0.08),
            ),
            child: Icon(
              cardSelected
                  ? (score > currentRound ? Icons.verified_rounded : Icons.warning_amber_rounded)
                  : Icons.shield,
              color: cardSelected
                  ? (score > currentRound ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                  : DigitalTheme.primaryCyan,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feedback.isEmpty ? 'ANALYZING PROFILES...' : feedback,
            textAlign: TextAlign.center,
            style: DigitalTheme.bodyStyle.copyWith(
              color: cardSelected 
                  ? (score > currentRound ? DigitalTheme.successGreen : DigitalTheme.dangerRed)
                  : DigitalTheme.primaryCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = profileRounds[currentRound];
    final retryKey = showRetry.toString() + currentRound.toString();
    
    return Scaffold(
      backgroundColor: DigitalTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: DigitalTheme.surfaceBackground,
        elevation: 0,
        title: Text(
          'CYBER SHIELD - PROFILE DETECTOR',
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
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatusBar(),
                        const SizedBox(height: 20),
                        _buildFeedbackPanel(),
                        const SizedBox(height: 30),
                        
                        if (!levelCompleted)
                          Container(
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
                          ),
                        
                        const SizedBox(height: 30),
                        
                        if (showRetry && !levelCompleted)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: resetLevel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DigitalTheme.cardBackground,
                                foregroundColor: DigitalTheme.primaryCyan,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: DigitalTheme.primaryCyan),
                                ),
                              ),
                              child: Text(
                                'RETRY ANALYSIS',
                                style: DigitalTheme.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        
                        if (levelCompleted)
                          Container(
                            margin: const EdgeInsets.all(16),
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
                            child: Column(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: DigitalTheme.successGreen,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'LEVEL COMPLETED',
                                  style: DigitalTheme.subheadingStyle.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: DigitalTheme.successGreen,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  ' Well done! You spotted the imposter and protected your digital identity. Always double-check friend requests and stay vigilant against online clones!',
                                  style: DigitalTheme.bodyStyle.copyWith(
                                    color: DigitalTheme.successGreen,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 20),
                        if (levelCompleted)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Level2Intro()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: Text('Next Level'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}