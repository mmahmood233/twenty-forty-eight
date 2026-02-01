# 2048 Game - Flutter Implementation

A modern implementation of the classic 2048 puzzle game built with Flutter, featuring smooth animations, clean architecture, and a warm color theme.

## 🎮 About

This is a faithful recreation of the popular 2048 game, implemented before its official April 2014 release. The objective is to slide numbered tiles on a 4x4 grid to combine them and create a tile with the number 2048.

## ✨ Features

- **4x4 Grid Gameplay**: Classic 2048 game mechanics
- **Smooth Animations**: 
  - Tile sliding with easeOutCubic curve (150ms)
  - Merge pop effect (100ms)
  - New tile spawn animation (120ms)
- **Intuitive Swipe Controls**: Native-feeling gesture detection with direction lock
- **Score Tracking**: 
  - Live current score display
  - Best score persistence using local storage
- **Game States**:
  - Win detection (reaching 2048)
  - Game over detection (no legal moves)
  - Continue playing after winning
- **Warm Color Theme**: Beautiful gradient colors for different tile values
- **Clean Architecture**: Separation of concerns (Domain, Data, Presentation)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/twenty-forty-eight.git
cd twenty-forty-eight
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🎯 How to Play

1. **Swipe** in any direction (up, down, left, right) to move all tiles
2. Tiles with the same number **merge** when they collide
3. Each move spawns a new tile (2 or 4) in a random empty spot
4. **Goal**: Create a tile with the number 2048
5. **Game Over**: When no legal moves are possible

## 🏗️ Architecture

The project follows **Clean Architecture** principles:

```
lib/
├── core/
│   ├── constants/     # Game configuration
│   └── theme/         # Colors and styling
├── domain/
│   ├── models/        # Business entities (Tile, Board, GameState)
│   └── services/      # Game logic (movement, merging, scoring)
├── data/
│   └── repositories/  # Data persistence (best score)
└── presentation/
    ├── providers/     # State management (Provider pattern)
    ├── screens/       # UI screens
    └── widgets/       # Reusable UI components
```

### Key Components

- **GameService**: Core game logic (tile movement, merging, spawn)
- **GameProvider**: State management and animation orchestration
- **ScoreRepository**: Persistent storage for best score
- **TileWidget**: Animated tile rendering with pixel-perfect positioning
- **GameBoardWidget**: 4x4 grid layout with background cells

## 🎨 Technical Highlights

### Animation System
- Uses `AnimatedPositioned` for smooth tile sliding
- `TweenAnimationBuilder` for spawn animations
- `AnimatedScale` for merge pop effects
- Proper sequencing: slide → merge → spawn

### Swipe Detection
- Pan gesture with 15px threshold
- Direction lock (prevents diagonal confusion)
- Input blocking during animations
- One move per gesture guarantee

### Game Over Logic
- Direct board scan (no swipe simulation)
- Checks for empty cells OR adjacent mergeable tiles
- O(n²) efficient algorithm

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1           # State management
  shared_preferences: ^2.2.2  # Local storage
  flutter_animate: ^4.5.0     # Animation utilities
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📱 Platform Support

- ✅ iOS
- ✅ Android
- ✅ macOS
- ✅ Web

## 🎯 Game Rules

1. Start with 2 tiles (value 2 or 4) randomly placed
2. Swipe to move all tiles in that direction
3. Tiles slide as far as possible until hitting the edge or another tile
4. Two tiles with the same value merge into one (value doubles)
5. Score increases by the value of merged tiles
6. New tile (2 or 4) appears after each valid move
7. Win by creating a 2048 tile
8. Lose when the board is full and no adjacent tiles can merge

## 🛠️ Development

### Code Style
- Follows Flutter/Dart style guide
- Clean architecture principles
- Immutable data models
- Unidirectional data flow

### Animation Timing
- Slide: 150ms (Curves.easeOutCubic)
- Merge: 100ms (Curves.easeOutCubic)
- Spawn: 120ms (Curves.easeOutBack)

### Grid Positioning Formula
```dart
cellSize = (boardSize - (gap * 5)) / 4
x = gap + col * (cellSize + gap)
y = gap + row * (cellSize + gap)
```

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by the original 2048 game by Gabriele Cirulli
- Built with Flutter and ❤️

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Enjoy playing 2048!** 🎮✨
