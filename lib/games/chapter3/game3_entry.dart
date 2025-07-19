import 'chapter3.dart';
import 'package:flutter/material.dart';
import 'package:claude/services/game_state.dart';

class Game3Entry extends StatelessWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game3Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chapter3MainPage(
      onGameComplete: () {
        // Mark chapter as completed in main app
        GameState().completeChapter(3);
        onGameComplete?.call();
      },
      onGameExit: () {
        onGameExit?.call();
      },
    );
  }
} 