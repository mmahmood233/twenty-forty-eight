class Position {
  final int row;
  final int col;

  const Position({
    required this.row,
    required this.col,
  });

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
