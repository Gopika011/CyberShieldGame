import 'package:flutter/material.dart';
import 'screens/level1_shop_or_stop.dart';
import 'screens/level2_permission_patrol.dart';
import 'screens/level3_wifi_woes.dart';
import 'widgets/cyber_button.dart';


class Game2Entry extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game2Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  _Game2EntryState createState() => _Game2EntryState();
}

class _Game2EntryState extends State<Game2Entry> {
  int totalScore = 0;

  void _handleGameComplete() {
    if (widget.onGameComplete != null) {
      widget.onGameComplete!();
    }
  }

  void _handleGameExit() {
    if (widget.onGameExit != null) {
      widget.onGameExit!();
    }
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
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // Header with score
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFFFAA00)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: const Color(0xFFFFAA00),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '3',
                          style: TextStyle(
                            color: const Color(0xFFFFAA00),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF00D4FF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.diamond,
                            color: const Color(0xFF00D4FF),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '$totalScore',
                            style: TextStyle(
                              color: const Color(0xFF00D4FF),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 40),
                
                // Game title section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00D4FF), width: 2),
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00D4FF).withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Hearts/lives
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, color: const Color(0xFF00D4FF), size: 20),
                          SizedBox(width: 16),
                          ...List.generate(4, (index) => 
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.favorite,
                                color: const Color(0xFF00D4FF),
                                size: 24,
                              ),
                            )
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.add, color: const Color(0xFF00D4FF), size: 20),
                          SizedBox(width: 16),
                          Icon(Icons.settings, color: const Color(0xFF00D4FF), size: 20),
                          SizedBox(width: 16),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.help,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Game title
                      Text(
                        'AWAKENING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'CHAPTER 2.1',
                        style: TextStyle(
                          color: const Color(0xFF00D4FF),
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Planet/circle with YOU and BOSS
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00FF88).withOpacity(0.3),
                              const Color(0xFF00FF88).withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF00FF88),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              top: 80,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: const Color(0xFF00FF88),
                                    size: 24,
                                  ),
                                  Text(
                                    'YOU',
                                    style: TextStyle(
                                      color: const Color(0xFF00FF88),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 80,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.dangerous,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  Text(
                                    'BOSS',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Level buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00D4FF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Level1ShopOrStop(),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  totalScore += result as int;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(
                                'LEVEL 1\nSHOP OR STOP',
                                style: TextStyle(
                                  color: const Color(0xFF00D4FF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFFAA00)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Level2PermissionPatrol(),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  totalScore += result as int;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(
                                'LEVEL 2\nPERMISSIONS',
                                style: TextStyle(
                                  color: const Color(0xFFFFAA00),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                   Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Level3WifiWoes(),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                totalScore += result as int;
                              });
                              
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: Text(
                              'LEVEL 3\nWI-FI WOES',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
                
                Spacer(),
                
                // Play button
                Column(
                  children: [
                    Text(
                      'TAP HERE',
                      style: TextStyle(
                        color: const Color(0xFFFFAA00),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFFFFAA00),
                      size: 24,
                    ),
                    SizedBox(height: 16),
                    CyberButton(
                      text: 'PLAY',
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Level1ShopOrStop(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            totalScore += result as int;
                          });
                        }
                      },
                      isLarge: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}