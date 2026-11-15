import 'package:equatable/equatable.dart';

import '../../../../core/map/map_point.dart';

enum BusStatus { onTime, delayed, early }

/// Live position and progress of one bus towards the user's stop.
class BusTracking extends Equatable {
  const BusTracking({
    required this.busId,
    required this.busNumber,
    required this.origin,
    required this.destination,
    required this.status,
    required this.etaMinutes,
    required this.stopsAway,
    required this.distanceMeters,
    required this.speedKmh,
    required this.progress,
    required this.busPosition,
    required this.passedPath,
    required this.upcomingPath,
    required this.stops,
  });

  final String busId;
  final String busNumber;
  final String origin;
  final String destination;
  final BusStatus status;

  /// Minutes until the bus reaches the user's stop.
  final int etaMinutes;
  final int stopsAway;
  final int distanceMeters;
  final int speedKmh;

  /// How far along the trip to the user's stop the bus is, 0..1.
  final double progress;

  final MapPoint busPosition;
  final List<MapPoint> passedPath;
  final List<MapPoint> upcomingPath;

  /// Stops in travel order.
  final List<RouteStop> stops;

  /// The stop the user is waiting at, if it is on this route.
  RouteStop? get userStop {
    for (final stop in stops) {
      if (stop.isUserStop) return stop;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    busId,
    busNumber,
    origin,
    destination,
    status,
    etaMinutes,
    stopsAway,
    distanceMeters,
    speedKmh,
    progress,
    busPosition,
    passedPath,
    upcomingPath,
    stops,
  ];
}

class RouteStop extends Equatable {
  const RouteStop({
    required this.name,
    required this.isPassed,
    required this.etaMinutes,
    required this.isUserStop,
    required this.position,
  });

  final String name;
  final bool isPassed;

  /// `null` once the bus has passed the stop.
  final int? etaMinutes;
  final bool isUserStop;
  final MapPoint position;

  @override
  List<Object?> get props => [name, isPassed, etaMinutes, isUserStop, position];
}
