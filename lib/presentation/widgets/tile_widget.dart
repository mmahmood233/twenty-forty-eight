import 'package:flutter/material.dart';
import '../../domain/models/tile.dart';
import '../../core/theme/app_colors.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final double cellSize;
  final double gap;

  const TileWidget({
    super.key,
    required this.tile,
    required this.cellSize,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final x = gap + tile.position.col * (cellSize + gap);
    final y = gap + tile.position.row * (cellSize + gap);
    
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      left: x,
      top: y,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: tile.isNew ? 120 : 0),
        curve: Curves.easeOutBack,
        tween: Tween(begin: tile.isNew ? 0.0 : 1.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: tile.isMerged ? 1.12 : 1.0,
          curve: Curves.easeOutCubic,
          onEnd: () {},
          child: Container(
            width: cellSize,
            height: cellSize,
            decoration: BoxDecoration(
              color: AppColors.getTileColor(tile.value),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${tile.value}',
                style: TextStyle(
                  fontSize: AppColors.getTileFontSize(tile.value),
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTileTextColor(tile.value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
