import 'package:flutter/foundation.dart';

// --- Base Challenge Class ---
abstract class Challenge {
  String get id;
  Map<String, dynamic> toJson();
}

// --- Game State and Player Models ---
enum GameStatus { notStarted, playing, paused, completed, failed }

@immutable
class GameState {
  final Player player;
  final GameStatus gameStatus;
  final int currentLevelIndex;
  final int timeRemaining;
  final int score;
  final int lives;
  final int challengesCompleted;
  final int correctAnswers;
  final int incorrectAnswers;
  final List<Challenge> remainingChallenges;

  const GameState({
    required this.player,
    this.gameStatus = GameStatus.notStarted,
    this.currentLevelIndex = 0,
    this.timeRemaining = 0,
    this.score = 0,
    this.lives = 3,
    this.challengesCompleted = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.remainingChallenges = const [],
  });

  // Add computed property for emails processed
  int get emailsProcessed => challengesCompleted;

  GameState copyWith({
    Player? player,
    GameStatus? gameStatus,
    int? currentLevelIndex,
    int? timeRemaining,
    int? score,
    int? lives,
    int? challengesCompleted,
    int? correctAnswers,
    int? incorrectAnswers,
    List<Challenge>? remainingChallenges,
  }) {
    return GameState(
      player: player ?? this.player,
      gameStatus: gameStatus ?? this.gameStatus,
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      remainingChallenges: remainingChallenges ?? this.remainingChallenges,
    );
  }
}

class Player {
  final String name;
  int score;
  int lives;
  int currentLevelIndex;
  List<Badge> badges;

  Player({
    required this.name,
    this.score = 0,
    this.lives = 3,
    this.currentLevelIndex = 0,
    this.badges = const [],
  });
}

// --- Specific Challenge Models ---
class Email extends Challenge {
  @override
  final String id;
  final String subject;
  final String sender;
  final String preview;
  final bool isPhishing;
  final String? phishingType;
  final List<String> indicators;
  final String? fullContent;

  Email({
    required this.id,
    required this.subject,
    required this.sender,
    required this.preview,
    required this.isPhishing,
    this.phishingType,
    required this.indicators,
    this.fullContent,
  });

  @override
  Map<String, dynamic> toJson() => {'id': id, 'subject': subject};
}

class LinkChallenge extends Challenge {
  @override
  final String id;
  final String displayUrl;
  final String actualUrl;
  final bool isLegitimate;
  final String description;
  final List<String> indicators;
  final String category;

  LinkChallenge({
    required this.id,
    required this.displayUrl,
    required this.actualUrl,
    required this.isLegitimate,
    required this.description,
    required this.indicators,
    required this.category,
  });

  @override
  Map<String, dynamic> toJson() => {'id': id, 'displayUrl': displayUrl};
}

class DialogueChallenge extends Challenge {
  @override
  final String id;
  final String scenario;
  final String message;
  final List<DialogueOption> options;
  final String explanation;
  final String category;

  DialogueChallenge({
    required this.id,
    required this.scenario,
    required this.message,
    required this.options,
    required this.explanation,
    required this.category,
  });

  @override
  Map<String, dynamic> toJson() => {'id': id, 'scenario': scenario};
}

class DialogueOption {
  final String id;
  final String text;
  final bool isCorrect;
  final String feedback;
  final int riskLevel;

  DialogueOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.feedback,
    required this.riskLevel,
  });
}

// --- Other Supporting Models ---
class Level {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<Challenge> challenges;
  final int timeLimit;
  final int passingScore;
  final Badge badge;

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.challenges,
    required this.timeLimit,
    required this.passingScore,
    required this.badge,
  });
}

class Chapter {
  final String id;
  final String name;
  final String description;
  final String story;
  final String theme;
  final List<Level> levels;
  final bool unlocked;

  Chapter({
    required this.id,
    required this.name,
    required this.description,
    required this.story,
    required this.theme,
    required this.levels,
    required this.unlocked,
  });
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

enum DropZoneType { legitimate, phishing }

class DropZone {
  final DropZoneType type;
  final String name;
  List<Email> emails;

  DropZone({
    required this.type,
    required this.name,
    this.emails = const [],
  });
}