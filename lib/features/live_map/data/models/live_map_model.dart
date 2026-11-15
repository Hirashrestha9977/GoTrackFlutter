import '../../../../core/map/map_point.dart';
import '../../domain/entities/live_map.dart';

/// Data-layer representation of [LiveMap] that knows about JSON.
class LiveMapModel extends LiveMap {
  const LiveMapModel({
    required super.updatedSecondsAgo,
    required super.userLocation,
    required super.routes,
    required super.buses,
  });

  factory LiveMapModel.fromJson(Map<String, dynamic> json) {
    return LiveMapModel(
      updatedSecondsAgo: json['updated_seconds_ago'] as int? ?? 0,
      userLocation: MapPoint.fromJson(
        json['user_location'] as Map<String, dynamic>,
      ),
      routes:
          (json['routes'] as List<dynamic>)
              .map<BusRoute>(
                (e) => BusRouteModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      buses:
          (json['buses'] as List<dynamic>)
              .map<NearbyBus>(
                (e) => NearbyBusModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class BusRouteModel extends BusRoute {
  const BusRouteModel({
    required super.id,
    required super.name,
    required super.path,
    required super.stops,
  });

  factory BusRouteModel.fromJson(Map<String, dynamic> json) {
    return BusRouteModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      path: MapPoint.listFromJson(json['path']),
      stops: MapPoint.listFromJson(json['stops']),
    );
  }
}

class NearbyBusModel extends NearbyBus {
  const NearbyBusModel({
    required super.id,
    required super.number,
    required super.routeId,
    required super.destination,
    required super.description,
    required super.etaMinutes,
    required super.distanceMeters,
    required super.position,
  });

  factory NearbyBusModel.fromJson(Map<String, dynamic> json) {
    return NearbyBusModel(
      id: json['id'].toString(),
      number: json['number'].toString(),
      routeId: json['route_id'].toString(),
      destination: json['destination'] as String? ?? '',
      description: json['description'] as String? ?? '',
      etaMinutes: json['eta_minutes'] as int,
      distanceMeters: json['distance_meters'] as int,
      position: MapPoint.fromJson(json['position'] as Map<String, dynamic>),
    );
  }
}
