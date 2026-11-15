import 'package:equatable/equatable.dart';

/// A position on the placeholder map, normalised to 0..1 on both axes
/// (0,0 = top-left of the map area).
///
/// When a real map SDK is added this becomes a latitude / longitude pair.
class MapPoint extends Equatable {
  const MapPoint(this.x, this.y);

  factory MapPoint.fromJson(Map<String, dynamic> json) {
    return MapPoint(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }

  static List<MapPoint> listFromJson(Object? json) {
    return (json as List<dynamic>)
        .map((e) => MapPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  final double x;
  final double y;

  @override
  List<Object?> get props => [x, y];
}
