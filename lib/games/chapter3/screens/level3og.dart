import 'package:claude/games/chapter3/widgets/feedback_panel.dart';
import 'package:claude/games/chapter3/widgets/game_app_bar.dart';
import 'package:claude/games/chapter3/widgets/game_background.dart';
import 'package:claude/games/chapter3/widgets/game_button.dart';
import 'package:claude/games/chapter3/widgets/game_status_bar.dart';
import 'package:claude/games/chapter3/widgets/level_complete_card.dart';
import 'package:claude/games/chapter3/widgets/theme.dart';
import 'package:claude/pages/land.dart';
import 'package:flutter/material.dart';
import '../chapter3.dart';
import 'level3_intro.dart';
import 'level1_intro.dart';
import '../../../pages/chapters_page.dart';
import '../../../services/game_state.dart';

class Level3 extends StatefulWidget {
  const Level3({super.key});

  @override
  State<Level3> createState() => _Level3State();
}

class _Level3State extends State<Level3> with TickerProviderStateMixin {
  int currentSection = 0;
  int score = 0;
  bool showFeedback = false;
  String feedbackMessage = '';
  String feedbackType = '';
  bool levelCompleted = false;

  // Section 1: Story Shield
  final List<Map<String, dynamic>> viewers = [
    {'name': 'Rahul_2.0', 'isFriend': false},
    {'name': 'coolguy001', 'isFriend': false},
    {'name': 'Priya', 'isFriend': true},
    {'name': 'stranger_123', 'isFriend': false},
    {'name': 'Aditi', 'isFriend': true},
  ];
  List<String> restricted = [];
  bool hideFromUnknownsTapped = false;

  // Section 2: Location Reveal
  bool locationRemoved = false;
  bool locationPrompted = false;

  // Section 3: DM Defense
  final List<Map<String, dynamic>> fakeDMs = [
    {
      'sender': 'stranger_123',
      'message': 'Hey 😘 wanna be friends?',
      'correct': 'Block',
    },
    {
      'sender': 'Rahul_2.0',
      'message': "Saw you at Mithila Café! Let's meet? 🥤",
      'correct': 'Report',
    },
    {
      'sender': 'coolguy001',
      'message': 'Nice pic! Can I DM you more? 😎',
      'correct': 'Block',
    },
  ];
  int currentDM = 0;
  bool dmAnswered = false;
  String dmSetting = 'Everyone';

  void nextSection() {
    setState(() {
      if (currentSection < 2) {
        currentSection++;
        showFeedback = false;
      } else {
        levelCompleted = true;
      }
    });
  }

  void handleStoryShieldAction({bool hideTapped = false, List<String>? restrictedList}) {
    bool correct = false;
    if (hideTapped) {
      correct = true;
    } else if (restrictedList != null) {
      correct = viewers.where((v) => !v['isFriend']).every((v) => restrictedList.contains(v['name']));
    }
    setState(() {
      if (correct) {
        score++;
        feedbackType = 'success';
        feedbackMessage = 'Great! Arya\'s story is now hidden from unknowns.';
      } else {
        feedbackType = 'error';
        feedbackMessage = 'Some strangers can still see Arya\'s story!';
      }
      showFeedback = true;
    });
    Future.delayed(const Duration(seconds: 2), nextSection);
  }

  void handleLocationAction(bool remove) {
    setState(() {
      if (remove) {
        score++;
        feedbackType = 'success';
        feedbackMessage = 'Smart! Location removed from Arya\'s post.';
      } else {
        feedbackType = 'error';
        feedbackMessage = 'Rahul_2.0 can still see Arya\'s location!';
      }
      showFeedback = true;
      locationPrompted = true;
    });
    Future.delayed(const Duration(seconds: 2), nextSection);
  }

  void handleDMAction(String action) {
    bool correct = action == fakeDMs[currentDM]['correct'];
    setState(() {
      if (correct) {
        score++;
        feedbackType = 'success';
        feedbackMessage = 'Good choice!';
      } else {
        feedbackType = 'error';
        feedbackMessage = 'That\'s not the safest option.';
      }
      showFeedback = true;
      dmAnswered = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
        if (currentDM < fakeDMs.length - 1) {
          currentDM++;
          dmAnswered = false;
        } else {
          nextSection();
        }
      });
    });
  }

  void handleDMSetting(String setting) {
    setState(() {
      dmSetting = setting;
      if (setting == 'Friends Only') {
        score++;
        feedbackType = 'success';
        feedbackMessage = 'Now only friends can DM Arya!';
      } else {
        feedbackType = 'error';
        feedbackMessage = 'Strangers can still send DMs!';
      }
      showFeedback = true;
    });
    Future.delayed(const Duration(seconds: 2), nextSection);
  }

  Widget _buildMainContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: levelCompleted ? _buildCompletionCard() : _buildSection(),
      ),
    );
  }

  Widget _buildSection() {
    switch (currentSection) {
      case 0:
        return _buildStoryShield();
      case 1:
        return _buildLocationReveal();
      case 2:
        return _buildDMDefense();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStoryShield() {
    return Column(
      children: [
        _buildSectionHeader('Story Shield', 'Control who sees Arya\'s story & posts.'),
        const SizedBox(height: 20),
        
        // Viewers Section - Responsive wrap instead of row
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DigitalTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'DRAG STRANGERS TO RESTRICT',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryCyan,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: viewers.map((v) {
                  bool isRestricted = restricted.contains(v['name']);
                  return Draggable<String>(
                    data: v['name'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildAvatar(v['name'], v['isFriend'], dragging: true),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildAvatar(v['name'], v['isFriend']),
                    ),
                    child: _buildAvatar(v['name'], v['isFriend'], restricted: isRestricted),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Restricted Zone - More compact
        DragTarget<String>(
          onAccept: (name) {
            setState(() {
              if (!restricted.contains(name)) {
                restricted.add(name);
              }
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 300),
              height: 80,
              decoration: BoxDecoration(
                color: DigitalTheme.dangerRed.withOpacity(0.1),
                border: Border.all(
                  color: candidateData.isNotEmpty 
                      ? DigitalTheme.dangerRed 
                      : DigitalTheme.dangerRed.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.block,
                      color: candidateData.isNotEmpty 
                          ? DigitalTheme.dangerRed 
                          : DigitalTheme.dangerRed.withOpacity(0.5),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'RESTRICTED ZONE',
                      style: DigitalTheme.subheadingStyle.copyWith(
                        color: candidateData.isNotEmpty 
                            ? DigitalTheme.dangerRed 
                            : DigitalTheme.dangerRed.withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (restricted.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${restricted.length} restricted',
                        style: DigitalTheme.bodyStyle.copyWith(
                          color: DigitalTheme.dangerRed.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Show feedback if available
        if (showFeedback) ...[
          GameFeedbackPanel(
            feedback: feedbackMessage,
            isSuccess: feedbackType == 'success',
            showFeedback: showFeedback,
            defaultMessage: 'ANALYZING SECURITY STATUS...',
          ),
          const SizedBox(height: 16),
        ],
        
        // Show options only when feedback is not showing
        if (!showFeedback) ...[
          // Clear restrictions button
          if (restricted.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextButton.icon(
                onPressed: () => setState(() => restricted.clear()),
                icon: Icon(Icons.clear, size: 16, color: DigitalTheme.warningOrange),
                label: Text(
                  'Clear Restrictions',
                  style: TextStyle(color: DigitalTheme.warningOrange, fontSize: 12),
                ),
              ),
            ),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: GameButton(
              text: 'SUBMIT CONFIGURATION',
              onPressed: () => handleStoryShieldAction(restrictedList: restricted),
              backgroundColor: DigitalTheme.primaryCyan,
              textColor: Colors.black,
              icon: Icons.security,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationReveal() {
    return Column(
      children: [
        _buildSectionHeader('Location Reveal', 'Arya tagged her location at Mithila Café'),
        const SizedBox(height: 20),
        
        // Location Card - More responsive
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DigitalTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: DigitalTheme.darkBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DigitalTheme.primaryCyan),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.map,
                        color: DigitalTheme.primaryCyan.withOpacity(0.5),
                        size: 50,
                      ),
                    ),
                    if (!locationRemoved)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: DigitalTheme.dangerRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '📍 Mithila Café, Kochi',
                style: DigitalTheme.bodyStyle.copyWith(
                  color: DigitalTheme.primaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Warning message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DigitalTheme.dangerRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DigitalTheme.dangerRed.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: DigitalTheme.dangerRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rahul_2.0 has just viewed this location!',
                  style: DigitalTheme.bodyStyle.copyWith(
                    color: DigitalTheme.dangerRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Show feedback if available
        if (showFeedback) ...[
          GameFeedbackPanel(
            feedback: feedbackMessage,
            isSuccess: feedbackType == 'success',
            showFeedback: showFeedback,
            defaultMessage: 'ANALYZING SECURITY STATUS...',
          ),
          const SizedBox(height: 16),
        ],
        
        // Show action buttons only when feedback is not showing
        if (!showFeedback && !locationPrompted) ...[
          // Action buttons - Always in column layout
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: GameButton(
                  text: 'REMOVE LOCATION',
                  onPressed: () {
                    setState(() => locationRemoved = true);
                    handleLocationAction(true);
                  },
                  backgroundColor: DigitalTheme.dangerRed,
                  textColor: Colors.white,
                  icon: Icons.location_off,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: GameButton(
                  text: 'KEEP TAGGED',
                  onPressed: () {
                    setState(() => locationRemoved = false);
                    handleLocationAction(false);
                  },
                  backgroundColor: DigitalTheme.cardBackground,
                  textColor: DigitalTheme.primaryText,
                  icon: Icons.location_on,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDMDefense() {
    final dm = fakeDMs[currentDM];
    return Column(
      children: [
        _buildSectionHeader('DM Defense', 'Suspicious message detected'),
        const SizedBox(height: 20),
        
        // Progress indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: DigitalTheme.primaryCyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Message ${currentDM + 1} of ${fakeDMs.length}',
            style: DigitalTheme.bodyStyle.copyWith(
              color: DigitalTheme.primaryCyan,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Message Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DigitalTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: DigitalTheme.dangerRed,
                    child: Text(
                      dm['sender'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dm['sender'],
                      style: DigitalTheme.subheadingStyle.copyWith(
                        color: DigitalTheme.primaryCyan,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DigitalTheme.darkBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.2)),
                ),
                child: Text(
                  dm['message'],
                  style: DigitalTheme.bodyStyle.copyWith(
                    color: DigitalTheme.primaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Show feedback if available
        if (showFeedback) ...[
          GameFeedbackPanel(
            feedback: feedbackMessage,
            isSuccess: feedbackType == 'success',
            showFeedback: showFeedback,
            defaultMessage: 'ANALYZING THREAT LEVEL...',
          ),
          const SizedBox(height: 16),
        ],
        
        // Show action buttons only when feedback is not showing
        if (!showFeedback && !dmAnswered) ...[
          // Action buttons - Always in column layout
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: GameButton(
                  text: 'ALLOW',
                  onPressed: () => handleDMAction('Allow'),
                  backgroundColor: DigitalTheme.cardBackground,
                  textColor: DigitalTheme.primaryText,
                  icon: Icons.check,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: GameButton(
                  text: 'BLOCK',
                  onPressed: () => handleDMAction('Block'),
                  backgroundColor: DigitalTheme.warningOrange,
                  textColor: Colors.white,
                  icon: Icons.block,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: GameButton(
                  text: 'REPORT',
                  onPressed: () => handleDMAction('Report'),
                  backgroundColor: DigitalTheme.dangerRed,
                  textColor: Colors.white,
                  icon: Icons.report,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DigitalTheme.primaryCyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DigitalTheme.primaryCyan.withOpacity(0.3)),
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
              Icons.security,
              color: DigitalTheme.primaryCyan,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: DigitalTheme.subheadingStyle.copyWith(
                    color: DigitalTheme.primaryCyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: DigitalTheme.bodyStyle.copyWith(
                    color: DigitalTheme.primaryText.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, bool isFriend, {bool dragging = false, bool restricted = false}) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dragging ? 50 : 45,
            height: dragging ? 50 : 45,
            decoration: BoxDecoration(
              color: isFriend ? DigitalTheme.successGreen : DigitalTheme.dangerRed,
              shape: BoxShape.circle,
              border: Border.all(
                color: restricted 
                    ? DigitalTheme.dangerRed 
                    : (isFriend ? DigitalTheme.successGreen : DigitalTheme.dangerRed),
                width: restricted ? 3 : 2,
              ),
              boxShadow: dragging ? [
                BoxShadow(
                  color: DigitalTheme.primaryCyan.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ] : null,
            ),
            child: Center(
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dragging ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: DigitalTheme.bodyStyle.copyWith(
                color: restricted ? DigitalTheme.dangerRed : DigitalTheme.primaryText,
                fontWeight: restricted ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    if (!levelCompleted) return const SizedBox.shrink();
    
    return LevelCompletionCard(
      title: 'PROFILE SECURED',
      message: score < 3 
          ? 'SECURITY LEVEL: COMPROMISED\nSome of Arya\'s information is still exposed. Review and retry.'
          : 'Excellent work! You\'ve successfully secured Arya\'s social media profile from potential threats.',
      score: score,
      maxScore: 5,
      nextButton: GameButton(
        text: 'RETURN TO BASE',
        onPressed: () {
          GameState().completeChapter(3);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ChaptersPage()),
            (route) => false,
          );
        },
        backgroundColor: DigitalTheme.primaryCyan,
        textColor: Colors.black,
        icon: Icons.home,
      ),
      retryButton: score < 3 
          ? GameButton(
              text: 'RETRY MISSION',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Level3Intro()),
                );
              },
              backgroundColor: DigitalTheme.dangerRed,
              textColor: Colors.white,
              icon: Icons.refresh,
              isIconRight: false,
            )
          : null,
      tips: const [
        'Always verify friend requests carefully',
        'Review privacy settings monthly',
        'Never share location in posts',
        'Keep message settings to friends only',
        'Report suspicious behavior immediately',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigitalTheme.darkBackground,
      appBar: const GameAppBar(title: 'CYBER SHIELD - SECURE PROFILE'),
      body: GameBackground(
        child: Column(
          children: [
            GameStatusBar(
              levelName: 'Level 3 - Active',
              score: score,
              maxScore: 5,
            ),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }
}