import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/swipe_direction.dart';
import '../providers/game_provider.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/score_card.dart';
import '../widgets/game_button.dart';
import '../../core/theme/app_colors.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: _buildGameBoard(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2048',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Row(
                  children: [
                    ScoreCard(
                      label: 'Score',
                      score: gameProvider.gameState.score,
                    ),
                    const SizedBox(width: 12),
                    ScoreCard(
                      label: 'Best',
                      score: gameProvider.gameState.bestScore,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Join the tiles, get to 2048!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                GameButton(
                  text: 'New Game',
                  icon: Icons.refresh,
                  onPressed: () => gameProvider.restart(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGameBoard(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final boardSize = (screenWidth - 32).clamp(300.0, 500.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < -100) {
                  gameProvider.move(SwipeDirection.up);
                } else if (details.primaryVelocity! > 100) {
                  gameProvider.move(SwipeDirection.down);
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < -100) {
                  gameProvider.move(SwipeDirection.left);
                } else if (details.primaryVelocity! > 100) {
                  gameProvider.move(SwipeDirection.right);
                }
              },
              child: GameBoardWidget(
                board: gameProvider.board,
                boardSize: boardSize,
              ),
            ),
            if (gameProvider.gameState.status == GameStatus.won)
              _buildWinOverlay(context, gameProvider),
            if (gameProvider.gameState.status == GameStatus.gameOver)
              _buildGameOverOverlay(context, gameProvider),
          ],
        );
      },
    );
  }

  Widget _buildWinOverlay(BuildContext context, GameProvider gameProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎉',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'You Win!',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${gameProvider.gameState.score}',
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GameButton(
                text: 'Continue',
                onPressed: () => gameProvider.continueAfterWin(),
              ),
              const SizedBox(width: 12),
              GameButton(
                text: 'New Game',
                icon: Icons.refresh,
                onPressed: () => gameProvider.restart(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, GameProvider gameProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Game Over!',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${gameProvider.gameState.score}',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          GameButton(
            text: 'Try Again',
            icon: Icons.refresh,
            onPressed: () => gameProvider.restart(),
          ),
        ],
      ),
    );
  }
}
