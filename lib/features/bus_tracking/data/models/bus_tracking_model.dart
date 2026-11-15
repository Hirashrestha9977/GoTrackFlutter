import '../../../../core/map/map_point.dart';
import '../../domain/entities/bus_tracking.dart';

/// Data-layer representation of [BusTracking] that knows about JSON.
class BusTrackingModel extends BusTracking {
  const BusTrackingModel({
    required super.busId,
    required super.busNumber,
    required super.origin,
    required super.destination,
    required super.status,
    required super.etaMinutes,
    required super.stopsAway,
    required super.distanceMeters,
    required super.speedKmh,
    required super.progress,
    required super.busPosition,
    required super.passedPath,
    required super.upcomingPath,
    required super.stops,
  });

  factory BusTrackingModel.fromJson(Map<String, dynamic> json) {
    return BusTrackingModel(
      busId: json['bus_id'].toString(),
      busNumber: json['bus_number'].toString(),
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      status: _statusFromJson(json['status'] as String?),
      etaMinutes: json['eta_minutes'] as int,
      stopsAway: json['stops_away'] as int,
      distanceMeters: json['distance_meters'] as int,
      speedKmh: (json['speed_kmh'] as num).round(),
      progress: (json['progress'] as num).toDouble().clamp(0.0, 1.0),
      busPosition: MapPoint.fromJson(
        json['bus_position'] as Map<String, dynamic>,
      ),
      passedPath: MapPoint.listFromJson(json['passed_path']),
      upcomingPath: MapPoint.listFromJson(json['upcoming_path']),
      stops:
          (json['stops'] as List<dynamic>)
              .map<RouteStop>(
                (e) => RouteStopModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  static BusStatus _statusFromJson(String? value) {
    return switch (value) {
      'delayed' => BusStatus.delayed,
      'early' => BusStatus.early,
      _ => BusStatus.onTime,
    };
  }
}

class RouteStopModel extends RouteStop {
  const RouteStopModel({
    required super.name,
    required super.isPassed,
    required super.etaMinutes,
    required super.isUserStop,
    required super.position,
  });

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      name: json['name'] as String? ?? '',
      isPassed: json['status'] == 'passed',
      etaMinutes: json['eta_minutes'] as int?,
      isUserStop: json['is_user_stop'] as bool? ?? false,
      position: MapPoint.fromJson(json['position'] as Map<String, dynamic>),
    );
  }
}
