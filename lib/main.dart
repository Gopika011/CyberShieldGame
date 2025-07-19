
// main.dart
import 'package:claude/games/chapter4/game4_entry.dart';
import 'package:claude/games/chapter3/game3_entry.dart';
import 'package:claude/pages/chapter_game_page.dart';
import 'package:claude/pages/chapters_page.dart';
import 'package:claude/pages/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CyberShieldApp());
}

class CyberShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberShield: Arya\'s Digital Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF0A0A0A),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFF00FFFF),
        ),
      ),
      home: LandingPage(),
      routes: {
        '/chapters': (context) => ChaptersPage(),
        '/chapter1': (context) => ChapterGamePage(chapterId: 1),
        '/chapter2': (context) => ChapterGamePage(chapterId: 2),
        '/chapter3': (context) => ChapterGamePage(chapterId: 3),
        '/chapter4': (context) => ChapterGamePage(chapterId: 4),
        '/chapter4/game': (context) => Game4Entry( 
          onGameComplete: () => Navigator.pop(context, 'completed'),
          onGameExit: () => Navigator.pop(context),
        ),
        '/chapter3/game': (context) => Game3Entry(
          onGameComplete: () => Navigator.pop(context, 'completed'),
          onGameExit: () => Navigator.pop(context),
        ),
      },
    );
  }
}