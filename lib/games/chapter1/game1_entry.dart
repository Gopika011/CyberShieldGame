import 'package:claude/enums/games.dart';
import 'package:claude/games/chapter4/pages/intruction_page.dart';
import 'package:flutter/material.dart';
import 'package:claude/games/chapter1/models/game_models.dart';
import 'package:claude/games/chapter1/screens/level1_inbox_invader.dart';
import 'package:claude/games/chapter1/service/game_state_service.dart';

class Game1Entry extends StatefulWidget {
  final VoidCallback? onGameComplete;
  final VoidCallback? onGameExit;

  const Game1Entry({
    Key? key,
    this.onGameComplete,
    this.onGameExit,
  }) : super(key: key);

  @override
  State<Game1Entry> createState() => _Game1EntryState();
}

class _Game1EntryState extends State<Game1Entry> {
  late final GameStateService gameService;

  @override
  void initState() {
    super.initState();
    gameService = GameStateService();
    gameService.startGame(levelIndex: 0);
    gameService.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    gameService.removeListener(_onGameStateChanged);
    super.dispose();
  }

  void _onGameStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return InstructionPage(
    //   gameType: GameType.ecommerceScam,
    //   nextGameWidget: Level1InboxInvader(
    //     emails: gameService.gameState.remainingChallenges.whereType<Email>().toList(),
    //     onEmailDrop: (email, isCorrect) {
    //       gameService.processEmail(email, isCorrect);
    //     },
    //   ),
    // );
    return Level1InboxInvader(
      emails: gameService.gameState.remainingChallenges.whereType<Email>().toList(),
      onEmailDrop: (email, isCorrect) {
        gameService.processEmail(email, isCorrect);
      },
    );
  }
}