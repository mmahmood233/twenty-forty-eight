import 'tile.dart';
import 'position.dart';

/// Represents the 4x4 game board containing all tiles.
///
/// Manages the collection of tiles and provides methods for
/// querying positions and checking board state.
class Board {
  /// List of all tiles currently on the board.
  final List<Tile> tiles;
  
  /// The size of the board (default 4 for a 4x4 grid).
  final int size;

  const Board({
    required this.tiles,
    this.size = 4,
  });

  /// Creates a copy of this board with optional new values.
  Board copyWith({
    List<Tile>? tiles,
    int? size,
  }) {
    return Board(
      tiles: tiles ?? this.tiles,
      size: size ?? this.size,
    );
  }

  /// Returns the tile at the specified position, or null if empty.
  ///
  /// Used to check if a position is occupied and retrieve tile data.
  Tile? getTileAt(Position position) {
    try {
      return tiles.firstWhere(
        (tile) => tile.position == position,
      );
    } catch (e) {
      return null;
    }
  }

  /// Checks if the specified position is empty (has no tile).
  bool isPositionEmpty(Position position) {
    return getTileAt(position) == null;
  }

  /// Returns a list of all empty positions on the board.
  ///
  /// Used for spawning new tiles in random empty locations.
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

  /// Checks if the board is completely full (no empty positions).
  ///
  /// Part of the game over detection logic.
  bool isFull() {
    return getEmptyPositions().isEmpty;
  }

  @override
  String toString() => 'Board(tiles: ${tiles.length}, size: $size)';
}
