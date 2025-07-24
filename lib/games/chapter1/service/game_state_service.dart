
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/game_models.dart';
import '../data/level_data.dart';

class GameStateService extends ChangeNotifier {
  static final GameStateService _instance = GameStateService._internal();
  factory GameStateService() => _instance;
  GameStateService._internal() {
    _initializeGame();
  }

  late GameState _gameState;
  late Player _player;
  Timer? _gameTimer;
  bool _isGameActive = false;

  GameState get gameState => _gameState;
  Player get player => _player;
  bool get isGameActive => _isGameActive;

  void _initializeGame() {
    _player = Player(name: 'Arya');
    _gameState = GameState(player: _player);
  }

  void startGame({required int levelIndex}) {
    print('🎮 Starting game for Level Index: $levelIndex');
    
    if (levelIndex < 0 || levelIndex >= LevelData.levels.length) {
      print("❌ ERROR: Invalid levelIndex $levelIndex passed to startGame.");
      return;
    }

    final level = LevelData.levels[levelIndex];
    
    // Reset game state for the new level
    _gameState = _gameState.copyWith(
      currentLevelIndex: levelIndex,
      gameStatus: GameStatus.playing,
      score: 0,
      lives: 3,
      timeRemaining: level.timeLimit,
      challengesCompleted: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      remainingChallenges: List<Challenge>.from(level.challenges),
    );
    
    _player.lives = 3;
    _player.score = 0; // Reset player score for new level
    _isGameActive = true;
    _startTimer();
    notifyListeners();
    
    print('🎯 Level started with ${level.challenges.length} challenges');
  }

  Level getCurrentLevel() {
    return LevelData.levels[_gameState.currentLevelIndex];
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState.gameStatus == GameStatus.playing && _isGameActive) {
        _gameState = _gameState.copyWith(timeRemaining: _gameState.timeRemaining - 1);
        
        if (_gameState.timeRemaining <= 0) {
          print('⏰ Time up! Completing level with current progress...');
          completeLevel(); // Complete the level instead of failing
        }
        notifyListeners();
      }
    });
  }

  void processEmail(Email email, bool isCorrectDrop) {
    if (!_isGameActive) return;
    
    print('📧 Processing email: ${email.subject} - Correct Drop: $isCorrectDrop');
    
    final bool wasAnswerCorrect = (!email.isPhishing && isCorrectDrop) || (email.isPhishing && !isCorrectDrop);

    // Remove the processed email from the remaining list
    final updatedChallenges = List<Challenge>.from(_gameState.remainingChallenges);
    updatedChallenges.removeWhere((c) => c.id == email.id);

    int scoreChange = 0;
    int livesChange = 0;

    if (wasAnswerCorrect) {
      scoreChange = 10;
      print('✅ Correct! Added $scoreChange points.');
    } else {
      livesChange = -1;
      print('❌ Incorrect! Lost a life.');
    }

    _gameState = _gameState.copyWith(
      remainingChallenges: updatedChallenges,
      challengesCompleted: _gameState.challengesCompleted + 1,
      correctAnswers: wasAnswerCorrect ? _gameState.correctAnswers + 1 : _gameState.correctAnswers,
      incorrectAnswers: !wasAnswerCorrect ? _gameState.incorrectAnswers + 1 : _gameState.incorrectAnswers,
      score: _gameState.score + scoreChange,
      lives: (_gameState.lives + livesChange).clamp(0, 3), // Ensure lives don't go negative
    );

    _player.score = _gameState.score; // Keep player score in sync
    _player.lives = _gameState.lives; // Keep player lives in sync
    
    print('📊 Current Stats: Score=${_gameState.score}, Correct=${_gameState.correctAnswers}, Incorrect=${_gameState.incorrectAnswers}, Completed=${_gameState.challengesCompleted}, Lives=${_gameState.lives}');

    _checkEndOfChallenge();
    notifyListeners();
  }

  void processLinkChallenge(LinkChallenge link, bool isCorrect) {
    if (!_isGameActive) return;
    
    print('🔗 Processing link: ${link.displayUrl} - Correct: $isCorrect');
    
    // Remove the processed link from the remaining list
    final updatedChallenges = List<Challenge>.from(_gameState.remainingChallenges);
    updatedChallenges.removeWhere((c) => c.id == link.id);

    int scoreChange = 0;
    int livesChange = 0;

    if (isCorrect) {
      scoreChange = 10;
      print('✅ Correct! Added $scoreChange points.');
    } else {
      livesChange = -1;
      print('❌ Incorrect! Lost a life.');
    }

    _gameState = _gameState.copyWith(
      remainingChallenges: updatedChallenges,
      challengesCompleted: _gameState.challengesCompleted + 1,
      correctAnswers: isCorrect ? _gameState.correctAnswers + 1 : _gameState.correctAnswers,
      incorrectAnswers: !isCorrect ? _gameState.incorrectAnswers + 1 : _gameState.incorrectAnswers,
      score: _gameState.score + scoreChange,
      lives: (_gameState.lives + livesChange).clamp(0, 3), // Ensure lives don't go negative
    );

    _player.score = _gameState.score; // Keep player score in sync
    _player.lives = _gameState.lives; // Keep player lives in sync
    
    print('📊 Current Stats: Score=${_gameState.score}, Correct=${_gameState.correctAnswers}, Incorrect=${_gameState.incorrectAnswers}, Completed=${_gameState.challengesCompleted}, Lives=${_gameState.lives}');
    
    _checkEndOfChallenge();
    notifyListeners();
  }

  void processDialogueChallenge(DialogueChallenge dialogue, DialogueOption option) {
    if (!_isGameActive) return;
    
    print('💬 Processing dialogue: ${dialogue.scenario} - Correct: ${option.isCorrect}');
    
    // Remove the processed dialogue from the remaining list
    final updatedChallenges = List<Challenge>.from(_gameState.remainingChallenges);
    updatedChallenges.removeWhere((c) => c.id == dialogue.id);

    int scoreChange = 0;
    int livesChange = 0;

    if (option.isCorrect) {
      scoreChange = 10;
      print('✅ Correct! Added $scoreChange points.');
    } else {
      livesChange = -1;
      print('❌ Incorrect! Lost a life.');
    }

    _gameState = _gameState.copyWith(
      remainingChallenges: updatedChallenges,
      challengesCompleted: _gameState.challengesCompleted + 1,
      correctAnswers: option.isCorrect ? _gameState.correctAnswers + 1 : _gameState.correctAnswers,
      incorrectAnswers: !option.isCorrect ? _gameState.incorrectAnswers + 1 : _gameState.incorrectAnswers,
      score: _gameState.score + scoreChange,
      lives: (_gameState.lives + livesChange).clamp(0, 3), // Ensure lives don't go negative
    );

    _player.score = _gameState.score; // Keep player score in sync
    _player.lives = _gameState.lives; // Keep player lives in sync
    
    print('📊 Current Stats: Score=${_gameState.score}, Correct=${_gameState.correctAnswers}, Incorrect=${_gameState.incorrectAnswers}, Completed=${_gameState.challengesCompleted}, Lives=${_gameState.lives}');
    
    _checkEndOfChallenge();
    notifyListeners();
  }
  
  void _checkEndOfChallenge() {
    final totalChallenges = getCurrentLevel().challenges.length;
    final remainingChallenges = _gameState.remainingChallenges.length;
    
    print('🔍 Checking end condition: ${_gameState.challengesCompleted}/$totalChallenges completed, $remainingChallenges remaining, Lives: ${_gameState.lives}');
    
    // Check if all challenges are completed first (primary win condition)
    if (_gameState.remainingChallenges.isEmpty && _gameState.challengesCompleted >= totalChallenges) {
      print('🎉 Level complete! All ${totalChallenges} challenges finished.');
      completeLevel();
      return;
    }

    // Only fail if lives are 0 AND we haven't completed all challenges
    if (_gameState.lives <= 0 && remainingChallenges > 0) {
      _gameState = _gameState.copyWith(gameStatus: GameStatus.failed);
      _isGameActive = false;
      _gameTimer?.cancel();
      print('💀 Game Over - No lives remaining with ${remainingChallenges} challenges left');
      return;
    }

    print('⏳ Game continues: ${remainingChallenges} challenges remaining, Lives: ${_gameState.lives}');
  }

  void completeLevel() {
    if (!mounted) return;
    print('🏆 Level ${_gameState.currentLevelIndex + 1} completed!');
    
    _isGameActive = false;
    _gameTimer?.cancel();

    // Calculate time bonus
    int timeBonus = _gameState.timeRemaining * 2;
    int finalScore = _gameState.score + timeBonus;
    
    // Update game state with final score
    _gameState = _gameState.copyWith(
      gameStatus: GameStatus.completed,
      score: finalScore,
    );
    
    // Update player score with bonus
    _player.score = finalScore;
    
    // Unlock next level
    if (_gameState.currentLevelIndex >= _player.currentLevelIndex) {
      _player.currentLevelIndex = _gameState.currentLevelIndex + 1;
    }
    
    print('⏰ Time bonus: $timeBonus points. Final score: $finalScore');
    print('📈 Final Stats: Score=$finalScore, Accuracy=${getAccuracy()}%, Correct=${_gameState.correctAnswers}, Incorrect=${_gameState.incorrectAnswers}');
    print('🎯 Player total score: ${_player.score}');
    
    notifyListeners();
  }

  void pauseGame() {
    if (_gameState.gameStatus == GameStatus.playing) {
      _gameState = _gameState.copyWith(gameStatus: GameStatus.paused);
      _isGameActive = false;
      _gameTimer?.cancel();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_gameState.gameStatus == GameStatus.paused) {
      _gameState = _gameState.copyWith(gameStatus: GameStatus.playing);
      _isGameActive = true;
      _startTimer();
      notifyListeners();
    }
  }

  void resetGame() {
    print('🔄 Resetting game');
    _gameTimer?.cancel();
    startGame(levelIndex: _gameState.currentLevelIndex);
  }
  
  int getAccuracy() {
    if (_gameState.challengesCompleted == 0) return 0;
    return ((_gameState.correctAnswers / _gameState.challengesCompleted) * 100).round();
  }

  String getFormattedTime() {
    int mins = _gameState.timeRemaining ~/ 60;
    int secs = _gameState.timeRemaining % 60;
    return '${mins}:${secs.toString().padLeft(2, '0')}';
  }

  bool get mounted => true;

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}