import 'package:flutter/material.dart';
import '../../domain/models/board.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import 'tile_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final Board board;
  final double boardSize;

  const GameBoardWidget({
    super.key,
    required this.board,
    required this.boardSize,
  });

  @override
  Widget build(BuildContext context) {
    final tileSize = boardSize / GameConstants.boardSize;

    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          _buildEmptyGrid(tileSize),
          _buildTiles(tileSize),
        ],
      ),
    );
  }

  Widget _buildEmptyGrid(double tileSize) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GameConstants.boardSize,
      ),
      itemCount: GameConstants.boardSize * GameConstants.boardSize,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.emptyTile,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Widget _buildTiles(double tileSize) {
    return Stack(
      children: board.tiles.map((tile) {
        return TileWidget(
          key: ValueKey(tile.id),
          tile: tile,
          size: tileSize,
        );
      }).toList(),
    );
  }
}
