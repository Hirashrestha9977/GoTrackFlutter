import 'package:equatable/equatable.dart';

import '../../../../core/map/map_point.dart';

/// Everything the Live map tab shows: routes, buses near the user and
/// how fresh the data is.
class LiveMap extends Equatable {
  const LiveMap({
    required this.updatedSecondsAgo,
    required this.userLocation,
    required this.routes,
    required this.buses,
  });

  final int updatedSecondsAgo;
  final MapPoint userLocation;
  final List<BusRoute> routes;
  final List<NearbyBus> buses;

  @override
  List<Object?> get props => [updatedSecondsAgo, userLocation, routes, buses];
}

class BusRoute extends Equatable {
  const BusRoute({
    required this.id,
    required this.name,
    required this.path,
    required this.stops,
  });

  final String id;
  final String name;
  final List<MapPoint> path;
  final List<MapPoint> stops;

  @override
  List<Object?> get props => [id, name, path, stops];
}

class NearbyBus extends Equatable {
  const NearbyBus({
    required this.id,
    required this.number,
    required this.routeId,
    required this.destination,
    required this.description,
    required this.etaMinutes,
    required this.distanceMeters,
    required this.position,
  });

  final String id;
  final String number;
  final String routeId;
  final String destination;

  /// Short route hint, e.g. "via Jamal".
  final String description;
  final int etaMinutes;
  final int distanceMeters;
  final MapPoint position;

  @override
  List<Object?> get props => [
    id,
    number,
    routeId,
    destination,
    description,
    etaMinutes,
    distanceMeters,
    position,
  ];
}
