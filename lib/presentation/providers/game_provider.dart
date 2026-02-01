import 'package:flutter/foundation.dart';
import '../../domain/models/board.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/swipe_direction.dart';
import '../../domain/services/game_service.dart';
import '../../data/repositories/score_repository.dart';

class GameProvider extends ChangeNotifier {
  final GameService _gameService;
  final ScoreRepository _scoreRepository;

  Board _board;
  GameState _gameState;
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

  Board get board => _board;
  GameState get gameState => _gameState;
  bool get isAnimating => _isAnimating;

  Future<void> _initialize() async {
    final bestScore = await _scoreRepository.getBestScore();
    _board = _gameService.initializeBoard();
    _gameState = _gameState.copyWith(bestScore: bestScore);
    notifyListeners();
  }

  Future<void> move(SwipeDirection direction) async {
    if (_isAnimating || _gameState.isGameOver) return;

    _isAnimating = true;
    notifyListeners();

    final result = _gameService.move(_board, direction);

    if (!result.moved) {
      _isAnimating = false;
      notifyListeners();
      return;
    }

    _board = result.board;
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

    await Future.delayed(const Duration(milliseconds: 250));
    _isAnimating = false;
    notifyListeners();
  }

  Future<void> restart() async {
    _board = _gameService.initializeBoard();
    _gameState = _gameState.copyWith(
      score: 0,
      status: GameStatus.playing,
    );
    _isAnimating = false;
    notifyListeners();
  }

  void continueAfterWin() {
    if (_gameState.status == GameStatus.won) {
      _gameState = _gameState.copyWith(status: GameStatus.playing);
      notifyListeners();
    }
  }
}
