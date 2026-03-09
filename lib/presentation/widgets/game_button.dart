import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable styled button widget for game actions.
///
/// Supports optional icon and uses the warm color theme.
class GameButton extends StatelessWidget {
  /// Button label text.
  final String text;
  
  /// Callback when button is pressed.
  final VoidCallback onPressed;
  
  /// Optional icon to display before text.
  final IconData? icon;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
