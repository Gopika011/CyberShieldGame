import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:flutter/material.dart';
import 'screens/level1_shop_or_stop.dart';

class Game2Entry extends StatelessWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game2Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InstructionPage(
      gameType: GameType.ecommerceScam,
      nextGameWidget: Level1ShopOrStop(
        onGameComplete: onGameComplete,
        onGameExit: onGameExit,
      ),
      onExitChapter: onGameExit,
    );
  }
}