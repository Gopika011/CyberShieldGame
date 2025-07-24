class GameState {
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal();

  List<int> unlockedChapters = [1]; // Chapter 1 unlocked by default
  List<int> completedChapters = [];

  void completeChapter(int chapterId) {
    if (!completedChapters.contains(chapterId)) {
      completedChapters.add(chapterId);
    }
    
    // Unlock next chapter
    if (chapterId < 5 && !unlockedChapters.contains(chapterId + 1)) {
      unlockedChapters.add(chapterId + 1);
    }
  }

  bool isChapterUnlocked(int chapterId) {
    return unlockedChapters.contains(chapterId);
  }

  bool isChapterCompleted(int chapterId) {
    return completedChapters.contains(chapterId);
  }
}