/// Represents the four possible swipe directions in the game.
///
/// Used to determine which direction tiles should move when the player swipes.
enum SwipeDirection {
  /// Swipe upward - tiles move toward the top of the board.
  up,
  
  /// Swipe downward - tiles move toward the bottom of the board.
  down,
  
  /// Swipe left - tiles move toward the left edge of the board.
  left,
  
  /// Swipe right - tiles move toward the right edge of the board.
  right,
}
