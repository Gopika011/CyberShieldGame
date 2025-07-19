import 'package:claude/games/chapter3/widgets/theme.dart';
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
  int currentSection = 0; // 0: Story Shield, 1: Location Reveal, 2: DM Defense
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
      'message': 'Saw you at Mithila Café! Let’s meet? 🥤',
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
      // All strangers must be in restricted
      correct = viewers.where((v) => !v['isFriend']).every((v) => restrictedList.contains(v['name']));
    }
    setState(() {
      if (correct) {
        score++;
        feedbackType = 'success';
        feedbackMessage = '✅ Great! Arya’s story is now hidden from unknowns.';
      } else {
        feedbackType = 'error';
        feedbackMessage = '⚠️ Some strangers can still see Arya’s story!';
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
        feedbackMessage = '✅ Smart! Location removed from Arya’s post.';
      } else {
        feedbackType = 'error';
        feedbackMessage = '⚠️ Rahul_2.0 can still see Arya’s location!';
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
        feedbackMessage = '✅ Good choice!';
      } else {
        feedbackType = 'error';
        feedbackMessage = '⚠️ That’s not the safest option.';
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
        feedbackMessage = '✅ Now only friends can DM Arya!';
      } else {
        feedbackType = 'error';
        feedbackMessage = '⚠️ Strangers can still send DMs!';
      }
      showFeedback = true;
    });
    Future.delayed(const Duration(seconds: 2), nextSection);
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
                'Level 2 - Active',
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
                '$score/${fakeDMs.length}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF334155),
        elevation: 0,
        title: Text(
          'CYBER SHIELD - SECURE PROFILE',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A1A2A),
              const Color(0xFF0F1B2A),
              const Color(0xFF0A1A2A),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildStatusBar(),
            const SizedBox(height: 20),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.05,
                    colorFilter: ColorFilter.mode(
                      const Color(0xFF00D4FF).withOpacity(0.1),
                      BlendMode.overlay,
                    ),
                  ),
                ),
                child: Center(
                  child: levelCompleted
                      ? SingleChildScrollView(
                          child: _buildCompletion(),
                        )
                      : _buildSection(),
                ),
              ),
            ),
            // Feedback Panel (old Level 3 style, overflow-safe)
            if (showFeedback)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: feedbackType == 'success'
                        ? [const Color(0xFF00FF88).withOpacity(0.2), const Color(0xFF00FF88).withOpacity(0.1)]
                        : [const Color(0xFFFFA726).withOpacity(0.2), const Color(0xFFFFA726).withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: feedbackType == 'success' ? const Color(0xFF00FF88) : const Color(0xFFFFA726),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (feedbackType == 'success' ? const Color(0xFF00FF88) : const Color(0xFFFFA726)).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: feedbackType == 'success' ? const Color(0xFF00FF88) : const Color(0xFFFFA726),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        feedbackType == 'success' ? Icons.check_circle : Icons.warning,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feedbackMessage,
                        style: TextStyle(
                          color: feedbackType == 'success' ? const Color(0xFF00FF88) : const Color(0xFFFFA726),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A2A3A), const Color(0xFF0F1B2A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Section 1: Story Shield',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00D4FF), letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          const Text(
            '🔓 Control who sees Arya’s story & posts.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: viewers.map((v) {
              bool isRestricted = restricted.contains(v['name']);
              return Draggable<String>(
                data: v['name'],
                feedback: _buildAvatar(v['name'], v['isFriend'], dragging: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildAvatar(v['name'], v['isFriend']),
                ),
                child: _buildAvatar(v['name'], v['isFriend'], restricted: isRestricted),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          DragTarget<String>(
            onAccept: (name) {
              setState(() {
                restricted.add(name);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  border: Border.all(color: const Color(0xFFFF4444), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '🔒 Restricted',
                    style: TextStyle(
                      color: candidateData.isNotEmpty ? const Color(0xFFFF4444) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                handleStoryShieldAction(restrictedList: restricted);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                elevation: 8,
              ),
              child: const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, bool isFriend, {bool dragging = false, bool restricted = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: dragging ? 32 : 28,
            backgroundColor: isFriend ? Colors.green : Colors.red,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: restricted ? Colors.red : Colors.white,
              fontWeight: restricted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationReveal() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A2A3A), const Color(0xFF0F1B2A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Section 2: Location Reveal',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00D4FF), letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          const Text(
            '🗺️ Arya\'s Post',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            '📍 Tag: "Mithila Café, Kochi"',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                ),
                child: const Icon(Icons.map, color: Colors.white54, size: 80),
              ),
              if (!locationRemoved)
                Positioned(
                  right: 16,
                  top: 16,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on, color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '🚨 Rahul_2.0 has just viewed this location!',
            style: TextStyle(color: Color(0xFFFF4444), fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (!locationPrompted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        locationRemoved = false;
                      });
                      handleLocationAction(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099CC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      elevation: 8,
                    ),
                    child: const Text('KEEP IT TAGGED'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        locationRemoved = true;
                      });
                      handleLocationAction(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      elevation: 8,
                    ),
                    child: const Text('REMOVE LOCATION'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDMDefense() {
    if (currentDM < fakeDMs.length) {
      final dm = fakeDMs[currentDM];
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A2A3A), const Color(0xFF0F1B2A)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Section 3: DM Defense',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00D4FF), letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            Text(
              'From: ${dm['sender']}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
              ),
              child: Text(
                dm['message'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            if (!dmAnswered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => handleDMAction('Allow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0099CC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        elevation: 8,
                      ),
                      child: const Text('ALLOW'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => handleDMAction('Block'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        elevation: 8,
                      ),
                      child: const Text('BLOCK'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => handleDMAction('Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        elevation: 8,
                      ),
                      child: const Text('REPORT'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    } else {
      // DM Settings
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A2A3A), const Color(0xFF0F1B2A)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Who can message Arya?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00D4FF), letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: [dmSetting == 'Everyone', dmSetting == 'Friends Only'],
              onPressed: (idx) {
                handleDMSetting(idx == 0 ? 'Everyone' : 'Friends Only');
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF00D4FF),
              color: Colors.white70,
              borderColor: const Color(0xFF00D4FF),
              selectedBorderColor: const Color(0xFF00D4FF),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Everyone'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Friends Only'),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCompletion() {
  return Container(
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

    
    child: Stack(
      children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                gridColor: const Color(0x1A00D4FF),
                cellSize: 25,
              ),
            ),
          ),
        // Main content
        Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1B2A).withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF00D4FF).withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF88).withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00FF88).withOpacity(0.1),
                          const Color(0xFF00D4FF).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      ' MISSION ACCOMPLISHED ',
                      style: TextStyle(
                        color: Color(0xFF00FF88),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Score section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1B2A).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ACCOUNT SECURED',
                          style: TextStyle(
                            color: Color(0xFF00D4FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'ve protected Arya from online threats!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF00FF88).withOpacity(0.2),
                                    const Color(0xFF00D4FF).withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF00FF88).withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'SCORE: $score/5',
                                style: const TextStyle(
                                  color: Color(0xFF00FF88),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Security Tips Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1B2A).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4FF),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '💡 SECURITY PROTOCOLS',
                              style: TextStyle(
                                color: Color(0xFF00D4FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            _buildSecurityTip('Always verify friend requests'),
                            _buildSecurityTip('Review privacy settings monthly'),
                            _buildSecurityTip('Never share location in posts'),
                            _buildSecurityTip('Keep your account private'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        GameState().completeChapter(3);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ChaptersPage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home, size: 20),
                      label: const Text('RETURN TO BASE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  
                  if (score < 3) ...[
                    const SizedBox(height: 20),
                    
                    // Warning section for low score
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF4444).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4444).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.warning,
                                  color: Color(0xFFFF4444),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'SECURITY BREACH DETECTED',
                                  style: TextStyle(
                                    color: Color(0xFFFF4444),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Some of Arya\'s information is still exposed! Review your privacy settings and try again to fully secure her account.',
                            style: TextStyle(
                              color: Color(0xFFFFAAAA),
                              fontSize: 14,
                              height: 1.4,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Level3Intro()),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('RETRY MISSION'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSecurityTip(String tip) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF00D4FF),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(
              color: Color(0xFFB8C6DB),
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    ),
  );
}
} 