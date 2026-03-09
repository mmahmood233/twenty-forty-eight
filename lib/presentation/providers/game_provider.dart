import 'package:flutter/foundation.dart';
import '../../domain/models/board.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/swipe_direction.dart';
import '../../domain/services/game_service.dart';
import '../../data/repositories/score_repository.dart';

/// State management provider for the 2048 game.
///
/// Manages the game board, game state, and coordinates between
/// the game service and UI. Extends [ChangeNotifier] for reactive updates.
class GameProvider extends ChangeNotifier {
  /// Service handling game logic (movement, merging, etc.).
  final GameService _gameService;
  
  /// Repository for persisting best score.
  final ScoreRepository _scoreRepository;

  /// Current state of the game board.
  Board _board;
  
  /// Current game state (status, scores).
  GameState _gameState;
  
  /// Flag to prevent input during animations.
  bool _isAnimating = false;

  GameProvider({
    required GameService gameService,
    required ScoreRepository scoreRepository,
  })  : _gameService = gameService,
        _scoreRepository = scoreRepository,
        _board = Board(tiles: []),
        _gameState = const GameState(
          status: GameStatus.playing,
          score: 0,
          bestScore: 0,
        ) {
    _initialize();
  }

  /// Public accessor for the current board state.
  Board get board => _board;
  
  /// Public accessor for the current game state.
  GameState get gameState => _gameState;
  
  /// Whether animations are currently playing.
  bool get isAnimating => _isAnimating;

  /// Initializes the game by loading best score and creating initial board.
  Future<void> _initialize() async {
    final bestScore = await _scoreRepository.getBestScore();
    _board = _gameService.initializeBoard();
    _gameState = _gameState.copyWith(bestScore: bestScore);
    notifyListeners();
  }

  /// Executes a move in the specified direction with proper animation sequencing.
  ///
  /// Animation sequence:
  /// 1. Move tiles to new positions (slide animation)
  /// 2. Show merge effects (pop animation)
  /// 3. Spawn new tile (scale-in animation)
  /// 4. Update score and check win/lose conditions
  Future<void> move(SwipeDirection direction) async {
    if (_isAnimating || _gameState.isGameOver) return;

    _isAnimating = true;

    final result = _gameService.move(_board, direction);

    if (!result.moved) {
      _isAnimating = false;
      return;
    }

    final tilesWithoutNew = result.board.tiles.where((t) => !t.isNew).toList();
    _board = Board(tiles: tilesWithoutNew.map((t) => t.copyWith(isNew: false, isMerged: false)).toList());
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 150));

    final mergedTiles = tilesWithoutNew.map((t) {
      final originalTile = result.board.tiles.firstWhere(
        (original) => original.id == t.id,
        orElse: () => t,
      );
      return t.copyWith(
        value: originalTile.value,
        isMerged: originalTile.value != t.value,
      );
    }).toList();
    
    _board = Board(tiles: mergedTiles);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    _board = result.board;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 120));

    final newScore = _gameState.score + result.scoreGained;
    final newBestScore = newScore > _gameState.bestScore ? newScore : _gameState.bestScore;

    if (newBestScore > _gameState.bestScore) {
      await _scoreRepository.saveBestScore(newBestScore);
    }

    final hasWon = _gameService.hasWon(_board);
    final canMove = _gameService.canMove(_board);

    GameStatus newStatus = _gameState.status;
    if (hasWon && _gameState.status != GameStatus.won) {
      newStatus = GameStatus.won;
    } else if (!canMove) {
      newStatus = GameStatus.gameOver;
    }

    _gameState = _gameState.copyWith(
      score: newScore,
      bestScore: newBestScore,
      status: newStatus,
    );

    _isAnimating = false;
    notifyListeners();
  }

  /// Restarts the game with a fresh board and resets the score.
  ///
  /// Preserves the best score across restarts.
  Future<void> restart() async {
    _board = _gameService.initializeBoard();
    _gameState = _gameState.copyWith(
      score: 0,
      status: GameStatus.playing,
    );
    _isAnimating = false;
    notifyListeners();
  }

  /// Allows the player to continue playing after reaching 2048.
  void continueAfterWin() {
    if (_gameState.status == GameStatus.won) {
      _gameState = _gameState.copyWith(status: GameStatus.playing);
      notifyListeners();
    }
  }
}
