import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter4/pages/chapter4_level1.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:claude/services/game_state.dart';
import 'package:flutter/material.dart';

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
    return InstructionPage(
      gameType: GameType.spamCall,
      nextGameWidget: Chapter4MainPage(
        onGameComplete: onGameComplete,
        onGameExit: onGameExit,
      ),
      onExitChapter: onGameExit,
    );
  }
}