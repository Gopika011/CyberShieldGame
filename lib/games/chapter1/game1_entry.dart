import 'package:claude/games/chapter1/models/game_models.dart';
import 'package:claude/games/chapter1/screens/level1_inbox_invader.dart';
import 'package:claude/games/chapter1/service/game_state_service.dart';
import 'package:flutter/material.dart';

class Game1Entry extends StatelessWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game1Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameService = GameStateService(); // Get the singleton instance

    return Level1InboxInvader(
      emails: gameService.gameState.remainingChallenges.whereType<Email>().toList(),
      onEmailDrop: (email, isCorrect) {
        gameService.processEmail(email, isCorrect);
      },
    );
  }
}