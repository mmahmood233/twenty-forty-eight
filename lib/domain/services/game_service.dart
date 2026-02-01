import 'dart:math';
import '../models/board.dart';
import '../models/tile.dart';
import '../models/position.dart';
import '../models/swipe_direction.dart';
import '../../core/constants/game_constants.dart';

class GameService {
  final Random _random = Random();

  Board initializeBoard() {
    final tiles = <Tile>[];
    final emptyPositions = _getAllPositions();

    for (int i = 0; i < GameConstants.initialTileCount; i++) {
      final position = emptyPositions.removeAt(_random.nextInt(emptyPositions.length));
      tiles.add(_createNewTile(position, isNew: false));
    }

    return Board(tiles: tiles);
  }

  List<Position> _getAllPositions() {
    final positions = <Position>[];
    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        positions.add(Position(row: row, col: col));
      }
    }
    return positions;
  }

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

  bool hasWon(Board board) {
    return board.tiles.any((tile) => tile.value >= GameConstants.winningTile);
  }
}

class MoveResult {
  final Board board;
  final int scoreGained;
  final bool moved;

  const MoveResult({
    required this.board,
    required this.scoreGained,
    required this.moved,
  });
}

class LineResult {
  final List<Tile> tiles;
  final int score;
  final bool moved;

  const LineResult({
    required this.tiles,
    required this.score,
    required this.moved,
  });
}
