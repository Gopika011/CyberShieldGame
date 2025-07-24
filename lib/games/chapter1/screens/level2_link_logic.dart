import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';
import '../widgets/digital_components.dart';
import 'package:claude/enums/games.dart';
import 'package:claude/pages/summary_page.dart';
import 'package:claude/painters/grid_painter.dart';
import 'package:claude/games/chapter1/screens/level3_reply_right.dart';
import '../data/level_data.dart';

class Level2LinkLogic extends StatefulWidget {
  final List<LinkChallenge> links;
  final Function(LinkChallenge, bool) onLinkSelected;

  const Level2LinkLogic({
    Key? key,
    required this.links,
    required this.onLinkSelected,
  }) : super(key: key);

  @override
  State<Level2LinkLogic> createState() => _Level2LinkLogicState();
}

class _Level2LinkLogicState extends State<Level2LinkLogic> {
  int currentLinkIndex = 0;
  bool showingFeedback = false;
  bool? selectedAnswer;
  List<Map<String, dynamic>> results = [];
  bool levelCompleted = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = DigitalTheme.isMobile(context);

    if (levelCompleted) {
      // Show summary page after completion
      return SummaryPage(
        results: results,
        totalQuestions: widget.links.length,
        gameType: GameType.phishing,
        onContinue: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Level3ReplyRight(
                dialogues: LevelData.level3Dialogues,
                onOptionSelected: (dialogue, option) {},
              ),
            ),
          );
        },
        onRetry: () {
          setState(() {
            currentLinkIndex = 0;
            showingFeedback = false;
            selectedAnswer = null;
            results.clear();
            levelCompleted = false;
          });
        },
      );
    }

    if (currentLinkIndex >= widget.links.length) {
      // Mark level as completed and show summary
      setState(() {
        levelCompleted = true;
      });
      return const SizedBox.shrink();
    }

    final currentLink = widget.links[currentLinkIndex];

    return Stack(
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
            painter: GridPainter(
              gridColor: const Color(0x1A00D4FF),
              cellSize: 25,
            ),
          ),
        ),
        // Main content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 8 : 12),
                      decoration: BoxDecoration(
                        gradient: DigitalTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: DigitalTheme.neonGlow,
                      ),
                      child: Icon(
                        Icons.link,
                        color: DigitalTheme.primaryText,
                        size: DigitalTheme.getMobileIconSize(context),
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Link Logic',
                            style: DigitalTheme.getMobileHeadingStyle(context),
                          ),
                          Text(
                            'Identify legitimate URLs from fake ones',
                            style: DigitalTheme.getMobileBodyStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main card container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x05FFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top accent bar
                        Container(
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00D4FF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        // Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProgressIndicator(context),
                                SizedBox(height: isMobile ? 16 : 24),
                                _buildInstructions(context),
                                SizedBox(height: isMobile ? 16 : 24),
                                Expanded(
                                  child: showingFeedback
                                      ? _buildFeedback(context, currentLink, selectedAnswer!)
                                      : _buildLinkChallenge(context, currentLink),
                                ),
                              ],
                            ),
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
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = DigitalTheme.isMobile(context);
    
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            gradient: DigitalTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: DigitalTheme.neonGlow,
          ),
          child: Icon(
            Icons.link,
            color: DigitalTheme.primaryText,
            size: DigitalTheme.getMobileIconSize(context),
          ),
        ),
        SizedBox(width: isMobile ? 12 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Link Logic',
                style: DigitalTheme.getMobileHeadingStyle(context),
              ),
              Text(
                'Identify legitimate URLs from fake ones',
                style: DigitalTheme.getMobileBodyStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final isMobile = DigitalTheme.isMobile(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Link ${currentLinkIndex + 1} of ${widget.links.length}',
              style: DigitalTheme.captionStyle.copyWith(
                fontSize: DigitalTheme.getResponsiveFontSize(context, 11, 12, 14),
              ),
            ),
            Text(
              '${((currentLinkIndex / widget.links.length) * 100).toInt()}%',
              style: DigitalTheme.captionStyle.copyWith(
                color: DigitalTheme.primaryCyan,
                fontSize: DigitalTheme.getResponsiveFontSize(context, 11, 12, 14),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 6 : 8),
        Container(
          height: isMobile ? 3 : 4,
          decoration: BoxDecoration(
            color: DigitalTheme.surfaceBackground,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: currentLinkIndex / widget.links.length,
            child: Container(
              decoration: BoxDecoration(
                gradient: DigitalTheme.primaryGradient,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: DigitalTheme.primaryCyan.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(BuildContext context) {
    final isMobile = DigitalTheme.isMobile(context);
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: DigitalTheme.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DigitalTheme.accentBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: DigitalTheme.accentBlue,
            size: DigitalTheme.getMobileIconSize(context),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Text(
              'Look carefully at each URL. Check for misspellings, suspicious domains, and security indicators.',
              style: DigitalTheme.getMobileBodyStyle(context).copyWith(
                color: DigitalTheme.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkChallenge(BuildContext context, LinkChallenge link) {
    final isMobile = DigitalTheme.isMobile(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Is this URL legitimate or fake?',
          style: DigitalTheme.subheadingStyle.copyWith(
            fontSize: DigitalTheme.getResponsiveFontSize(context, 14, 16, 18),
          ),
        ),
        
        SizedBox(height: isMobile ? 16 : 24),
        
        // URL Display - NEUTRAL BLUE COLOR FOR ALL
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DigitalTheme.cardBackground,
                DigitalTheme.surfaceBackground,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DigitalTheme.primaryCyan.withOpacity(0.5), // SAME BLUE FOR ALL
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language,
                    color: DigitalTheme.primaryCyan, // SAME BLUE FOR ALL
                    size: DigitalTheme.getMobileIconSize(context),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Text(
                    'Website URL',
                    style: DigitalTheme.captionStyle.copyWith(
                      color: DigitalTheme.primaryCyan, // SAME BLUE FOR ALL
                      fontSize: DigitalTheme.getResponsiveFontSize(context, 11, 12, 14),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              // URL Text - NEUTRAL BLUE COLOR
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: DigitalTheme.darkBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: DigitalTheme.primaryCyan.withOpacity(0.3), // SAME BLUE FOR ALL
                    width: 1,
                  ),
                ),
                child: Text(
                  link.displayUrl,
                  style: TextStyle(
                    fontSize: DigitalTheme.getResponsiveFontSize(context, 14, 16, 18),
                    fontFamily: 'monospace',
                    color: DigitalTheme.primaryCyan, // SAME BLUE FOR ALL - NO HINTS!
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              Text(
                link.description,
                style: DigitalTheme.getMobileBodyStyle(context),
              ),
            ],
          ),
        ),
        
        SizedBox(height: isMobile ? 20 : 32),
        
        // Answer Buttons
        Row(
          children: [
            Expanded(
              child: _buildAnswerButton(
                context,
                'Legitimate',
                Icons.shield,
                DigitalTheme.neonGreen,
                () => _selectAnswer(link, true),
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: _buildAnswerButton(
                context,
                'Fake',
                Icons.warning,
                DigitalTheme.dangerRed,
                () => _selectAnswer(link, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    final isMobile = DigitalTheme.isMobile(context);
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: DigitalTheme.getMobileButtonHeight(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: DigitalTheme.getMobileIconSize(context),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: DigitalTheme.getResponsiveFontSize(context, 14, 16, 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(BuildContext context, LinkChallenge link, bool userAnswer) {
    final isMobile = DigitalTheme.isMobile(context);
    final isCorrect = userAnswer == link.isLegitimate;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feedback Header
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: isCorrect 
                ? DigitalTheme.neonGreen.withOpacity(0.1)
                : DigitalTheme.dangerRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect 
                  ? DigitalTheme.neonGreen
                  : DigitalTheme.dangerRed,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect 
                    ? DigitalTheme.neonGreen
                    : DigitalTheme.dangerRed,
                size: DigitalTheme.getMobileIconSize(context) + 8,
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Correct!' : 'Incorrect',
                      style: DigitalTheme.subheadingStyle.copyWith(
                        color: isCorrect 
                            ? DigitalTheme.neonGreen
                            : DigitalTheme.dangerRed,
                        fontSize: DigitalTheme.getResponsiveFontSize(context, 16, 18, 20),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.isLegitimate 
                          ? 'This URL is legitimate'
                          : 'This URL is fake/malicious',
                      style: DigitalTheme.getMobileBodyStyle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: isMobile ? 16 : 20),
        
        // Indicators
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: DigitalTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DigitalTheme.accentBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key Indicators:',
                style: DigitalTheme.subheadingStyle.copyWith(
                  color: DigitalTheme.accentBlue,
                  fontSize: DigitalTheme.getResponsiveFontSize(context, 14, 16, 18),
                ),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              ...link.indicators.map((indicator) => Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 4 : 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: DigitalTheme.getMobileBodyStyle(context).copyWith(
                        color: DigitalTheme.accentBlue.withOpacity(0.8),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        indicator,
                        style: DigitalTheme.getMobileBodyStyle(context).copyWith(
                          color: DigitalTheme.accentBlue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Continue Button
        Center(
          child: DigitalButton(
            text: currentLinkIndex < widget.links.length - 1 
                ? 'Next Link' 
                : 'Complete Level',
            onPressed: _nextLink,
            isPrimary: true,
            icon: Icons.arrow_forward,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen() {
    return DigitalCard(
      glowEffect: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: DigitalTheme.primaryGradient,
                borderRadius: BorderRadius.circular(50),
                boxShadow: DigitalTheme.neonGlow,
              ),
              child: const Icon(
                Icons.check_circle,
                color: DigitalTheme.primaryText,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Level Complete!',
              style: DigitalTheme.headingStyle.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Arya learned how to identify fake URLs!',
              style: DigitalTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _selectAnswer(LinkChallenge link, bool answer) {
    setState(() {
      selectedAnswer = answer;
      showingFeedback = true;
      results.add({
        'isCorrect': answer == link.isLegitimate,
        'question': link.displayUrl,
        'answer': link.isLegitimate ? 'Legitimate' : 'Fake',
        'userAnswer': answer ? 'Legitimate' : 'Fake',
      });
    });
    widget.onLinkSelected(link, answer == link.isLegitimate);
  }

  void _nextLink() {
    if (currentLinkIndex < widget.links.length - 1) {
      setState(() {
        currentLinkIndex++;
        showingFeedback = false;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        levelCompleted = true;
      });
    }
  }
}