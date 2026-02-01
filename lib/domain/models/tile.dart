import 'position.dart';

class Tile {
  final int value;
  final Position position;
  final String id;
  final bool isNew;
  final bool isMerged;

  const Tile({
    required this.value,
    required this.position,
    required this.id,
    this.isNew = false,
    this.isMerged = false,
  });

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
