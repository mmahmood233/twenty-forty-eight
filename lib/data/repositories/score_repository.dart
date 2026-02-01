import 'package:shared_preferences/shared_preferences.dart';

class ScoreRepository {
  static const String _bestScoreKey = 'best_score';

  Future<int> getBestScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_bestScoreKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> saveBestScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bestScoreKey, score);
    } catch (e) {
      return;
    }
  }

  Future<void> clearBestScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bestScoreKey);
    } catch (e) {
      return;
    }
  }
}
