import 'package:claude/games/chapter4/pages/chapter4_level1.dart';
import 'package:flutter/material.dart';
import 'package:claude/services/game_state.dart';

class Game4Entry extends StatelessWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game4Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chapter4MainPage(
      onGameComplete: () {
        // Mark chapter as completed in main app
        GameState().completeChapter(4);
        onGameComplete?.call();
      },
      onGameExit: () {
        onGameExit?.call();
      },
    );
  }
}