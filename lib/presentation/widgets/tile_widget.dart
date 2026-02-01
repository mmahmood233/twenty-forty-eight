import 'package:flutter/material.dart';
import '../../domain/models/tile.dart';
import '../../core/theme/app_colors.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final double size;

  const TileWidget({
    super.key,
    required this.tile,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      left: tile.position.col * size,
      top: tile.position.row * size,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: tile.isNew ? 1.0 : (tile.isMerged ? 1.1 : 1.0),
        curve: Curves.easeInOut,
        child: Container(
          width: size - 12,
          height: size - 12,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.getTileColor(tile.value),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
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
    );
  }
}
