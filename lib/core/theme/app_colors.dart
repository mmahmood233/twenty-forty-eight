import 'package:flutter/material.dart';

/// Color palette for the 2048 game with warm theme.
///
/// Provides all colors used in the UI, including tile colors,
/// backgrounds, and text colors.
class AppColors {
  /// Main background color for the app.
  static const Color background = Color(0xFFFAF8EF);
  
  /// Background color for the game board.
  static const Color boardBackground = Color(0xFFBBADA0);
  
  /// Color for empty tile slots on the board.
  static const Color emptyTile = Color(0xFFCDC1B4);
  
  /// Dark text color (used for low-value tiles: 2, 4).
  static const Color textDark = Color(0xFF776E65);
  
  /// Light text color (used for high-value tiles: 8+).
  static const Color textLight = Color(0xFFF9F6F2);
  
  /// Background color for score cards.
  static const Color scoreBackground = Color(0xFFBBADA0);
  
  /// Background color for buttons.
  static const Color buttonBackground = Color(0xFF8F7A66);
  
  /// Returns the background color for a tile based on its value.
  ///
  /// Colors range from light beige (2) to dark gold (2048+).
  static Color getTileColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return const Color(0xFF3C3A32);
    }
  }
  
  /// Returns the text color for a tile based on its value.
  ///
  /// Dark text for values 2 and 4, light text for higher values.
  static Color getTileTextColor(int value) {
    return value <= 4 ? textDark : textLight;
  }
  
  /// Returns the appropriate font size for a tile based on its value.
  ///
  /// Larger numbers use smaller fonts to fit within the tile.
  static double getTileFontSize(int value) {
    if (value < 100) return 55;
    if (value < 1000) return 45;
    if (value < 10000) return 35;
    return 30;
  }
}
