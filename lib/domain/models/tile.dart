import 'position.dart';

/// Represents a numbered tile on the game board.
///
/// Each tile has a value (2, 4, 8, 16, etc.), a position on the board,
/// and a unique identifier for tracking during animations.
class Tile {
  /// The numeric value displayed on the tile (2, 4, 8, 16, etc.).
  final int value;
  
  /// The current position of the tile on the board.
  final Position position;
  
  /// Unique identifier for this tile, used for animation tracking.
  final String id;
  
  /// Whether this tile was just spawned (triggers spawn animation).
  final bool isNew;
  
  /// Whether this tile was just created by merging (triggers merge animation).
  final bool isMerged;

  const Tile({
    required this.value,
    required this.position,
    required this.id,
    this.isNew = false,
    this.isMerged = false,
  });

  /// Creates a copy of this tile with optional new values.
  ///
  /// Used extensively for creating immutable state updates.
  Tile copyWith({
    int? value,
    Position? position,
    String? id,
    bool? isNew,
    bool? isMerged,
  }) {
    return Tile(
      value: value ?? this.value,
      position: position ?? this.position,
      id: id ?? this.id,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Tile(value: $value, position: $position, id: $id, isNew: $isNew, isMerged: $isMerged)';
}
