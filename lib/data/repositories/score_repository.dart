import 'package:shared_preferences/shared_preferences.dart';

/// Repository for persisting the best score across game sessions.
///
/// Uses SharedPreferences to store the highest score achieved.
class ScoreRepository {
  /// Key used to store the best score in SharedPreferences.
  static const String _bestScoreKey = 'best_score';

  /// Retrieves the best score from persistent storage.
  ///
  /// Returns 0 if no score has been saved or if an error occurs.
  Future<int> getBestScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_bestScoreKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Saves the best score to persistent storage.
  ///
  /// Should be called whenever a new high score is achieved.
  Future<void> saveBestScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bestScoreKey, score);
    } catch (e) {
      return;
    }
  }

  /// Clears the saved best score from storage.
  ///
  /// Useful for testing or resetting game statistics.
  Future<void> clearBestScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bestScoreKey);
    } catch (e) {
      return;
    }
  }
}
