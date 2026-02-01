import 'tile.dart';
import 'position.dart';

class Board {
  final List<Tile> tiles;
  final int size;

  const Board({
    required this.tiles,
    this.size = 4,
  });

  Board copyWith({
    List<Tile>? tiles,
    int? size,
  }) {
    return Board(
      tiles: tiles ?? this.tiles,
      size: size ?? this.size,
    );
  }

  Tile? getTileAt(Position position) {
    try {
      return tiles.firstWhere(
        (tile) => tile.position == position,
      );
    } catch (e) {
      return null;
    }
  }

  bool isPositionEmpty(Position position) {
    return getTileAt(position) == null;
  }

  List<Position> getEmptyPositions() {
    final emptyPositions = <Position>[];
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        final position = Position(row: row, col: col);
        if (isPositionEmpty(position)) {
          emptyPositions.add(position);
        }
      }
    }
    return emptyPositions;
  }

  bool isFull() {
    return getEmptyPositions().isEmpty;
  }

  @override
  String toString() => 'Board(tiles: ${tiles.length}, size: $size)';
}
