import 'package:claude/games/chapter1/widgets/digital_components.dart';
import 'package:claude/games/chapter1/widgets/digital_email_card.dart';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../theme/digital_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DigitalTheme.isMobile(context);

    return FuturisticFrame(
      borderColor: DigitalTheme.primaryCyan,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: DigitalTheme.cardGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
          ],
        ),
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

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildEmailList(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: _buildEnhancedDropZones(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: DigitalTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: DigitalTheme.neonGlow,
          ),
          child: const Icon(
            Icons.email,
            color: DigitalTheme.primaryText,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inbox Invader',
                style: DigitalTheme.headingStyle,
              ),
              Text(
                'Sort legitimate emails from phishing attempts',
                style: DigitalTheme.bodyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailList() {
    final remainingEmails = widget.emails;

    return FuturisticFrame(
      borderColor: DigitalTheme.primaryCyan,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: DigitalTheme.cardGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arya\'s Inbox (${remainingEmails.length} emails)',
              style: DigitalTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
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
                      child: ListView.builder(
                        key: ValueKey(remainingEmails.length),
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
      ),
    );
  }

  Widget _buildEnhancedDropZones() {
    final isMobile = DigitalTheme.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 5 : 5),
          child: Text(
            'Sort Emails',
            style: DigitalTheme.getMobileHeadingStyle(context).copyWith(
              fontSize: DigitalTheme.getResponsiveFontSize(context, 16, 18, 20),
            ),
          ),
        ),
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
        isLegitimate ? DigitalTheme.neonGreen : Colors.red;
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
        
        widget.onEmailDrop(email, isCorrect);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(isHovering ? 0.3 : 0.1),
                secondaryColor.withOpacity(isHovering ? 0.2 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primaryColor.withOpacity(isHovering ? 0.8 : 0.4),
              width: isHovering ? 4 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isHovering ? 0.4 : 0.2),
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
                    color: primaryColor.withOpacity(0.2),
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