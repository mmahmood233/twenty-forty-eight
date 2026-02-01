enum GameStatus {
  playing,
  won,
  gameOver,
}

class GameState {
  final GameStatus status;
  final int score;
  final int bestScore;
  final bool canUndo;

  const GameState({
    required this.status,
    required this.score,
    required this.bestScore,
    this.canUndo = false,
  });

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

  bool get isGameOver => status == GameStatus.gameOver;
  bool get hasWon => status == GameStatus.won;
  bool get isPlaying => status == GameStatus.playing;

  @override
  String toString() =>
      'GameState(status: $status, score: $score, bestScore: $bestScore, canUndo: $canUndo)';
}
