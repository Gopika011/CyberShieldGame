import 'package:claude/games/chapter1/widgets/digital_components.dart';
import 'package:claude/games/chapter1/widgets/digital_email_card.dart';
import 'package:claude/services/audio_effects.dart';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/painters/grid_painter.dart';
import 'package:claude/games/chapter1/screens/level2_link_logic.dart';
import '../data/level_data.dart';

class Level1InboxInvader extends StatefulWidget {
  final List<Email> emails;
  final Function(Email, bool) onEmailDrop;

  const Level1InboxInvader({
    Key? key,
    required this.emails,
    required this.onEmailDrop,
  }) : super(key: key);

  @override
  State<Level1InboxInvader> createState() => _Level1InboxInvaderState();
}

class _Level1InboxInvaderState extends State<Level1InboxInvader>
    with TickerProviderStateMixin {
  final List<DropZone> _dropZones = [
    DropZone(type: DropZoneType.legitimate, name: 'Legitimate', emails: []),
    DropZone(type: DropZoneType.phishing, name: 'Phishing', emails: []),
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late final ScrollController _scrollController;

  // Feedback state
  String feedbackMessage = '';
  bool showFeedback = false;
  bool isSuccess = false;
  List<Map<String, dynamic>> results = [];

  final AudioEffectsService _audioEffects = AudioEffectsService();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _scrollController = ScrollController();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleEmailDrop(Email email, bool isCorrect) {
    setState(() {
      showFeedback = true;
      isSuccess = isCorrect;
      feedbackMessage = isCorrect ? 'Correct! This email was sorted properly.' : 'Incorrect! Review the phishing indicators.';
      results.add({
        'email': email,
        'isCorrect': isCorrect,
        'subject': email.subject,
        'sender': email.sender,
        'isPhishing': email.isPhishing,
      });
      
      if (isSuccess){
        _audioEffects.playCorrect();
      }else{
        _audioEffects.playWrong();
      }
    });
    widget.onEmailDrop(email, isCorrect);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        showFeedback = false;
        feedbackMessage = '';
      });
      // If all emails are sorted, show summary
      if (widget.emails.isEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryPage(
                results: results.map((r) => {
                  'isCorrect': r['isCorrect'],
                  'question': r['subject'],
                  'answer': r['isPhishing'] ? 'Phishing' : 'Legitimate',
                  'userAnswer': r['isCorrect'] ? 'Correct' : 'Incorrect',
                }).toList(),
                totalQuestions: results.length,
                gameType: GameType.phishing,
                onContinue: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Level2LinkLogic(
                        links: LevelData.level2Links,
                        onLinkSelected: (link, isCorrect) {},
                      ),
                    ),
                  );
                },
                onRetry: () => Navigator.pop(context),
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DigitalTheme.isMobile(context);
    final totalEmails = LevelData.level1Emails.length; // Assuming you have this data
    final completedEmails = totalEmails - widget.emails.length;

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
                            'Email ${completedEmails + 1} of $totalEmails',
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
                        value: completedEmails / totalEmails,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                
                // Main card container
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
                              border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5), width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF00D4FF).withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.email,
                                    color: const Color(0xFF00D4FF),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'EMAIL SECURITY SCAN',
                                        style: TextStyle(
                                          color: Color(0xFF00D4FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'INBOX INVADER',
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
                          
                          // Instructions
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D4FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00D4FF).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF00D4FF),
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Drag each email to the correct category. Look for phishing indicators like suspicious senders and urgent language.',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFB8C6DB),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Main content
                          Expanded(
                            child: _buildMobileLayout(),
                          ),
                        ],
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

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: _buildEmailList(),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 3,
          child: _buildEnhancedDropZones(),
        ),
      ],
    );
  }

  Widget _buildEmailList() {
    final remainingEmails = widget.emails;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DigitalTheme.accentBlue.withOpacity(0.1),
            DigitalTheme.accentBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DigitalTheme.accentBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DigitalTheme.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inbox,
                  color: DigitalTheme.accentBlue,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ARYA\'S INBOX',
                style: TextStyle(
                  color: DigitalTheme.accentBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${remainingEmails.length} EMAILS',
                style: TextStyle(
                  color: DigitalTheme.accentBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (showFeedback)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSuccess 
                      ? DigitalTheme.neonGreen.withOpacity(0.1)
                      : DigitalTheme.dangerRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSuccess 
                        ? DigitalTheme.neonGreen
                        : DigitalTheme.dangerRed,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.cancel,
                      color: isSuccess ? DigitalTheme.neonGreen : DigitalTheme.dangerRed,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        feedbackMessage,
                        style: TextStyle(
                          color: isSuccess ? DigitalTheme.neonGreen : DigitalTheme.dangerRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: remainingEmails.isEmpty
                ? Center(
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 64,
                                color: DigitalTheme.neonGreen,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'All emails sorted!',
                                style: TextStyle(
                                  color: DigitalTheme.neonGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Scrollbar(
                    thumbVisibility: true,
                    // Only pass controller if not empty
                    controller: _scrollController,
                    child: ListView.builder(
                      key: ValueKey(remainingEmails.length),
                      // Only pass controller if not empty
                      controller: _scrollController,
                      itemCount: remainingEmails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Draggable<Email>(
                            data: remainingEmails[index],
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 300,
                                child: DigitalEmailCard(
                                  email: remainingEmails[index],
                                  onDrop: (email, zone) {},
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.4,
                              child: DigitalEmailCard(
                                email: remainingEmails[index],
                                onDrop: (email, zone) {},
                              ),
                            ),
                            child: DigitalEmailCard(
                              email: remainingEmails[index],
                              onDrop: (email, zone) {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDropZones() {
    final isMobile = DigitalTheme.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: isMobile
              ? Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildStyledDropZone(
                          dropZone: _dropZones[0],
                          isLegitimate: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildStyledDropZone(
                          dropZone: _dropZones[1],
                          isLegitimate: false,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStyledDropZone(
                        dropZone: _dropZones[0],
                        isLegitimate: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStyledDropZone(
                        dropZone: _dropZones[1],
                        isLegitimate: false,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildStyledDropZone({
    required DropZone dropZone,
    required bool isLegitimate,
  }) {
    final Color primaryColor =
        isLegitimate ? DigitalTheme.neonGreen : DigitalTheme.dangerRed;
    final Color secondaryColor =
        isLegitimate ? Colors.green.shade300 : Colors.red.shade300;
    final IconData icon = isLegitimate ? Icons.verified_user : Icons.warning;

    return DragTarget<Email>(
      onAccept: (email) {
        // Calculate if the drop is correct
        // - If email is phishing and dropped in phishing zone (isLegitimate = false) = correct
        // - If email is legitimate and dropped in legitimate zone (isLegitimate = true) = correct
        final bool isCorrect = (email.isPhishing && !isLegitimate) ||
            (!email.isPhishing && isLegitimate);
        _handleEmailDrop(email, isCorrect);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: (isLegitimate
                    ? DigitalTheme.successGreen.withOpacity(isHovering ? 0.08 : 0.03)
                    : DigitalTheme.dangerRed.withOpacity(isHovering ? 0.08 : 0.03)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(isHovering ? 0.8 : 0.4),
              width: isHovering ? 3 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isHovering ? 0.2 : 0.08),
                blurRadius: isHovering ? 20 : 12,
                spreadRadius: isHovering ? 3 : 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(icon, size: 20, color: primaryColor),
                      const SizedBox(height: 4),
                      Text(
                        isLegitimate ? 'Legitimate' : 'Phishing',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isHovering) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Drop here!',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}