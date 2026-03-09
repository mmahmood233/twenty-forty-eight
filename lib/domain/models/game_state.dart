/// Represents the current status of the game.
enum GameStatus {
  /// Game is actively being played.
  playing,
  
  /// Player has reached the 2048 tile.
  won,
  
  /// No more legal moves are possible.
  gameOver,
}

/// Represents the overall state of the game.
///
/// Tracks the game status, current score, best score, and undo capability.
class GameState {
  /// The current status of the game (playing, won, or game over).
  final GameStatus status;
  
  /// The current score for this game session.
  final int score;
  
  /// The best score ever achieved (persisted across sessions).
  final int bestScore;
  
  /// Whether the player can undo the last move (future feature).
  final bool canUndo;

  const GameState({
    required this.status,
    required this.score,
    required this.bestScore,
    this.canUndo = false,
  });

  /// Creates a copy of this game state with optional new values.
  GameState copyWith({
    GameStatus? status,
    int? score,
    int? bestScore,
    bool? canUndo,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      canUndo: canUndo ?? this.canUndo,
    );
  }

  /// Returns true if the game is over.
  bool get isGameOver => status == GameStatus.gameOver;
  
  /// Returns true if the player has won.
  bool get hasWon => status == GameStatus.won;
  
  /// Returns true if the game is currently being played.
  bool get isPlaying => status == GameStatus.playing;

  @override
  String toString() =>
      'GameState(status: $status, score: $score, bestScore: $bestScore, canUndo: $canUndo)';
}
