import 'package:equatable/equatable.dart';

/// A bus stop and the buses due to arrive at it.
class StopArrivals extends Equatable {
  const StopArrivals({
    required this.id,
    required this.name,
    required this.localName,
    required this.distanceMeters,
    required this.walkMinutes,
    required this.alertLeadMinutes,
    required this.alertsEnabled,
    required this.isSaved,
    required this.arrivals,
  });

  final String id;
  final String name;

  /// Name in Nepali script. Empty if unknown.
  final String localName;
  final int distanceMeters;
  final int walkMinutes;

  /// How many minutes before arrival the user is notified.
  final int alertLeadMinutes;
  final bool alertsEnabled;
  final bool isSaved;
  final List<Arrival> arrivals;

  @override
  List<Object?> get props => [
    id,
    name,
    localName,
    distanceMeters,
    walkMinutes,
    alertLeadMinutes,
    alertsEnabled,
    isSaved,
    arrivals,
  ];
}

class Arrival extends Equatable {
  const Arrival({
    required this.busId,
    required this.busNumber,
    required this.destination,
    required this.routeName,
    required this.etaMinutes,
  });

  final String busId;
  final String busNumber;
  final String destination;
  final String routeName;
  final int etaMinutes;

  @override
  List<Object?> get props => [
    busId,
    busNumber,
    destination,
    routeName,
    etaMinutes,
  ];
}
