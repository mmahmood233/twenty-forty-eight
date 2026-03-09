/// Central configuration for game rules and settings.
///
/// Contains all the constants that define game behavior,
/// including board size, winning conditions, and animation timings.
class GameConstants {
  /// The size of the game board (4x4 grid).
  static const int boardSize = 4;
  
  /// The tile value needed to win the game.
  static const int winningTile = 2048;
  
  /// Number of tiles to spawn at game start (3-4 per requirements).
  static const int initialTileCount = 3;
  
  /// Possible values for newly spawned tiles.
  static const List<int> possibleNewTileValues = [2, 4];
  
  /// Probability weights for new tile values (90% chance of 2, 10% chance of 4).
  static const List<int> newTileWeights = [9, 1];
  
  /// Duration for tile slide animations (deprecated, using 150ms in code).
  static const Duration animationDuration = Duration(milliseconds: 200);
  
  /// Duration for tile merge pop animations.
  static const Duration mergeAnimationDuration = Duration(milliseconds: 150);
  
  /// Duration for new tile spawn animations.
  static const Duration newTileAnimationDuration = Duration(milliseconds: 100);
}
