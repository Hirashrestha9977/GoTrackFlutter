import '../../domain/entities/location_trail.dart';

/// Data-layer representation of [LocationTrail] that knows about JSON.
class LocationTrailModel extends LocationTrail {
  const LocationTrailModel({
    required super.updatedSecondsAgo,
    required super.points,
  });

  factory LocationTrailModel.fromJson(Map<String, dynamic> json) {
    return LocationTrailModel(
      updatedSecondsAgo: json['updated_seconds_ago'] as int? ?? 0,
      points:
          (json['locations'] as List<dynamic>)
              .map<LocationPoint>(
                (e) => LocationPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class LocationPointModel extends LocationPoint {
  const LocationPointModel({
    required super.latitude,
    required super.longitude,
    super.place,
    super.recordedAt,
    super.speedKmh,
  });

  /// Only the position is required; the details are optional.
  factory LocationPointModel.fromJson(Map<String, dynamic> json) {
    return LocationPointModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      place: json['place'] as String? ?? '',
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? ''),
      speedKmh: (json['speed_kmh'] as num?)?.round(),
    );
  }
}
