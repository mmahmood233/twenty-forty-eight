class GameConstants {
  static const int boardSize = 4;
  static const int winningTile = 2048;
  static const int initialTileCount = 2;
  
  static const List<int> possibleNewTileValues = [2, 4];
  static const List<int> newTileWeights = [9, 1];
  
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const Duration mergeAnimationDuration = Duration(milliseconds: 150);
  static const Duration newTileAnimationDuration = Duration(milliseconds: 100);
}
