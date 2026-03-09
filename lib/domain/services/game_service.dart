import 'dart:math';
import '../models/board.dart';
import '../models/tile.dart';
import '../models/position.dart';
import '../models/swipe_direction.dart';
import '../../core/constants/game_constants.dart';

/// Core game logic service for the 2048 game.
///
/// Handles all game mechanics including:
/// - Board initialization
/// - Tile movement and merging
/// - Random tile generation
/// - Win/lose condition checking
class GameService {
  /// Random number generator for tile placement and values.
  final Random _random = Random();

  /// Initializes a new game board with the starting tiles.
  ///
  /// Creates 3 tiles with random positions and values (2 or 4).
  Board initializeBoard() {
    final tiles = <Tile>[];
    final emptyPositions = _getAllPositions();

    for (int i = 0; i < GameConstants.initialTileCount; i++) {
      final position = emptyPositions.removeAt(_random.nextInt(emptyPositions.length));
      tiles.add(_createNewTile(position, isNew: false));
    }

    return Board(tiles: tiles);
  }

  /// Returns a list of all possible positions on the board.
  ///
  /// Used for random tile placement during initialization.
  List<Position> _getAllPositions() {
    final positions = <Position>[];
    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        positions.add(Position(row: row, col: col));
      }
    }
    return positions;
  }

  /// Creates a new tile at the specified position.
  ///
  /// The tile value is randomly chosen (90% chance of 2, 10% chance of 4).
  /// The [isNew] flag triggers the spawn animation.
  Tile _createNewTile(Position position, {bool isNew = true}) {
    final value = _getRandomTileValue();
    final id = '${position.row}_${position.col}_${DateTime.now().millisecondsSinceEpoch}';
    return Tile(
      value: value,
      position: position,
      id: id,
      isNew: isNew,
    );
  }

  /// Generates a random tile value based on weighted probabilities.
  ///
  /// Returns 2 with 90% probability, 4 with 10% probability.
  int _getRandomTileValue() {
    final totalWeight = GameConstants.newTileWeights.reduce((a, b) => a + b);
    final randomValue = _random.nextInt(totalWeight);
    
    int cumulativeWeight = 0;
    for (int i = 0; i < GameConstants.possibleNewTileValues.length; i++) {
      cumulativeWeight += GameConstants.newTileWeights[i];
      if (randomValue < cumulativeWeight) {
        return GameConstants.possibleNewTileValues[i];
      }
    }
    return GameConstants.possibleNewTileValues[0];
  }

  /// Executes a move in the specified direction.
  ///
  /// Returns a [MoveResult] containing the new board state,
  /// score gained from merges, and whether any tiles moved.
  MoveResult move(Board board, SwipeDirection direction) {
    final List<Tile> movedTiles = [];
    final List<List<Tile>> lines = _getLines(board, direction);
    int scoreGained = 0;
    bool hasMoved = false;

    for (final line in lines) {
      final result = _mergeLine(line, direction);
      movedTiles.addAll(result.tiles);
      scoreGained += result.score;
      if (result.moved) hasMoved = true;
    }

    if (!hasMoved) {
      return MoveResult(
        board: board,
        scoreGained: 0,
        moved: false,
      );
    }

    final newBoard = board.copyWith(tiles: movedTiles);
    final emptyPositions = newBoard.getEmptyPositions();
    
    if (emptyPositions.isNotEmpty) {
      final randomPosition = emptyPositions[_random.nextInt(emptyPositions.length)];
      final newTile = _createNewTile(randomPosition);
      movedTiles.add(newTile);
    }

    return MoveResult(
      board: Board(tiles: movedTiles),
      scoreGained: scoreGained,
      moved: true,
    );
  }

  /// Organizes tiles into lines based on the swipe direction.
  ///
  /// For left/right: each row becomes a line.
  /// For up/down: each column becomes a line.
  /// Tiles are ordered from the direction of movement.
  List<List<Tile>> _getLines(Board board, SwipeDirection direction) {
    final lines = <List<Tile>>[];
    
    for (int i = 0; i < GameConstants.boardSize; i++) {
      final line = <Tile>[];
      for (int j = 0; j < GameConstants.boardSize; j++) {
        Position position;
        switch (direction) {
          case SwipeDirection.left:
            position = Position(row: i, col: j);
            break;
          case SwipeDirection.right:
            position = Position(row: i, col: GameConstants.boardSize - 1 - j);
            break;
          case SwipeDirection.up:
            position = Position(row: j, col: i);
            break;
          case SwipeDirection.down:
            position = Position(row: GameConstants.boardSize - 1 - j, col: i);
            break;
        }
        final tile = board.getTileAt(position);
        if (tile != null) {
          line.add(tile);
        }
      }
      if (line.isNotEmpty) {
        lines.add(line);
      }
    }
    
    return lines;
  }

  /// Processes a single line of tiles, merging and moving them.
  ///
  /// Returns a [LineResult] with the new tile positions, score gained,
  /// and whether any tiles moved.
  LineResult _mergeLine(List<Tile> line, SwipeDirection direction) {
    if (line.isEmpty) {
      return LineResult(tiles: [], score: 0, moved: false);
    }

    final mergedTiles = <Tile>[];
    int score = 0;
    bool moved = false;
    int currentIndex = 0;

    for (int i = 0; i < line.length; i++) {
      if (i < line.length - 1 && line[i].value == line[i + 1].value) {
        final newValue = line[i].value * 2;
        score += newValue;
        
        final newPosition = _getPositionForIndex(
          currentIndex,
          _getLineIndex(line[i].position, direction),
          direction,
        );
        
        mergedTiles.add(line[i].copyWith(
          value: newValue,
          position: newPosition,
          isMerged: true,
        ));
        
        if (line[i].position != newPosition) moved = true;
        currentIndex++;
        i++;
      } else {
        final newPosition = _getPositionForIndex(
          currentIndex,
          _getLineIndex(line[i].position, direction),
          direction,
        );
        
        mergedTiles.add(line[i].copyWith(
          position: newPosition,
          isMerged: false,
        ));
        
        if (line[i].position != newPosition) moved = true;
        currentIndex++;
      }
    }

    return LineResult(tiles: mergedTiles, score: score, moved: moved);
  }

  /// Returns the line index for a position based on swipe direction.
  ///
  /// For horizontal swipes: returns row number.
  /// For vertical swipes: returns column number.
  int _getLineIndex(Position position, SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
      case SwipeDirection.right:
        return position.row;
      case SwipeDirection.up:
      case SwipeDirection.down:
        return position.col;
    }
  }

  /// Calculates the board position for a tile at a given index in a line.
  ///
  /// Converts from line-based coordinates back to board coordinates,
  /// accounting for the swipe direction.
  Position _getPositionForIndex(int index, int lineIndex, SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return Position(row: lineIndex, col: index);
      case SwipeDirection.right:
        return Position(row: lineIndex, col: GameConstants.boardSize - 1 - index);
      case SwipeDirection.up:
        return Position(row: index, col: lineIndex);
      case SwipeDirection.down:
        return Position(row: GameConstants.boardSize - 1 - index, col: lineIndex);
    }
  }

  /// Checks if any legal moves are possible on the board.
  ///
  /// Returns true if:
  /// - There are empty positions, OR
  /// - Any adjacent tiles have the same value (can merge)
  ///
  /// Used for game over detection.
  bool canMove(Board board) {
    if (!board.isFull()) return true;

    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        final position = Position(row: row, col: col);
        final tile = board.getTileAt(position);
        if (tile == null) continue;

        if (col < GameConstants.boardSize - 1) {
          final rightTile = board.getTileAt(Position(row: row, col: col + 1));
          if (rightTile != null && rightTile.value == tile.value) return true;
        }

        if (row < GameConstants.boardSize - 1) {
          final bottomTile = board.getTileAt(Position(row: row + 1, col: col));
          if (bottomTile != null && bottomTile.value == tile.value) return true;
        }
      }
    }

    return false;
  }

  /// Checks if the player has won by reaching the 2048 tile.
  ///
  /// Returns true if any tile has a value >= 2048.
  bool hasWon(Board board) {
    return board.tiles.any((tile) => tile.value >= GameConstants.winningTile);
  }
}

/// Result of a move operation.
///
/// Contains the new board state, score gained from merges,
/// and whether any tiles actually moved.
class MoveResult {
  /// The board state after the move.
  final Board board;
  
  /// Points gained from tile merges during this move.
  final int scoreGained;
  
  /// Whether any tiles moved or merged.
  final bool moved;

  const MoveResult({
    required this.board,
    required this.scoreGained,
    required this.moved,
  });
}

/// Result of processing a single line of tiles.
///
/// Internal helper class for the merge algorithm.
class LineResult {
  /// The tiles in their new positions after merging.
  final List<Tile> tiles;
  
  /// Score gained from merges in this line.
  final int score;
  
  /// Whether any tiles in this line moved.
  final bool moved;

  const LineResult({
    required this.tiles,
    required this.score,
    required this.moved,
  });
}
