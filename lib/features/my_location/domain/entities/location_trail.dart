import 'package:equatable/equatable.dart';

/// One recorded position and what was known about it at the time.
class LocationPoint extends Equatable {
  const LocationPoint({
    required this.latitude,
    required this.longitude,
    this.place = '',
    this.recordedAt,
    this.speedKmh,
  });

  final double latitude;
  final double longitude;

  /// Human-readable name of the place; empty if unknown.
  final String place;
  final DateTime? recordedAt;
  final int? speedKmh;

  @override
  List<Object?> get props => [latitude, longitude, place, recordedAt, speedKmh];
}

/// The owner's recorded positions, oldest first.
class LocationTrail extends Equatable {
  const LocationTrail({required this.updatedSecondsAgo, required this.points});

  final int updatedSecondsAgo;

  /// Oldest first; the last entry is the most recent position.
  final List<LocationPoint> points;

  /// The most recent position, or `null` if nothing has been recorded.
  LocationPoint? get lastPoint => points.isEmpty ? null : points.last;

  @override
  List<Object?> get props => [updatedSecondsAgo, points];
}
