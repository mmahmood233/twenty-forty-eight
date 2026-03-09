/// Represents a position on the game board.
///
/// Uses zero-indexed row and column coordinates to identify
/// a specific cell in the 4x4 grid.
class Position {
  /// The row index (0-3) from top to bottom.
  final int row;
  
  /// The column index (0-3) from left to right.
  final int col;

  const Position({
    required this.row,
    required this.col,
  });

  /// Creates a copy of this position with optional new values.
  ///
  /// Useful for creating modified positions without mutating the original.
  Position copyWith({
    int? row,
    int? col,
  }) {
    return Position(
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position(row: $row, col: $col)';
}
