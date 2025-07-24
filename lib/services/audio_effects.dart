import 'package:audioplayers/audioplayers.dart';

class AudioEffectsService {
  static final AudioEffectsService _instance = AudioEffectsService._internal();
  factory AudioEffectsService() => _instance;
  AudioEffectsService._internal();

  final AudioPlayer _soundPlayer = AudioPlayer();

  // Sound effect paths
  static const String correctSound = 'audio/correct_chime.mp3';
  static const String wrongSound = 'audio/wrong_buzz_short.mp3';

  /// Play correct answer sound effect
  Future<void> playCorrect() async {
    try {
      await _soundPlayer.play(AssetSource(correctSound));
    } catch (e) {
      print("Error playing correct sound: $e");
    }
  }

  /// Play wrong answer sound effect
  Future<void> playWrong() async {
    try {
      await _soundPlayer.play(AssetSource(wrongSound));
    } catch (e) {
      print("Error playing wrong sound: $e");
    }
  }

  /// Play timeout sound effect (same as wrong)
  Future<void> playTimeout() async {
    await playWrong();
  }

  /// Stop sound effects
  Future<void> stop() async {
    await _soundPlayer.stop();
  }

  /// Dispose of the audio player
  void dispose() {
    _soundPlayer.dispose();
  }
}