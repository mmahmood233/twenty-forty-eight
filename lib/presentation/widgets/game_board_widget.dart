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
    const gap = 6.0;
    final cellSize = (boardSize - (gap * 5)) / 4;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          _buildEmptyGrid(cellSize, gap),
          _buildTiles(cellSize, gap),
        ],
      ),
    );
  }

  Widget _buildEmptyGrid(double cellSize, double gap) {
    final cells = <Widget>[];
    
    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        final x = gap + col * (cellSize + gap);
        final y = gap + row * (cellSize + gap);
        
        cells.add(
          Positioned(
            left: x,
            top: y,
            child: Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: AppColors.emptyTile,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      }
    }
    
    return Stack(children: cells);
  }

  Widget _buildTiles(double cellSize, double gap) {
    return Stack(
      children: board.tiles.map((tile) {
        return TileWidget(
          key: ValueKey(tile.id),
          tile: tile,
          cellSize: cellSize,
          gap: gap,
        );
      }).toList(),
    );
  }
}
