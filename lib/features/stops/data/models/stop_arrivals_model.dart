import '../../domain/entities/stop_arrivals.dart';

/// Data-layer representation of [StopArrivals] that knows about JSON.
class StopArrivalsModel extends StopArrivals {
  const StopArrivalsModel({
    required super.id,
    required super.name,
    required super.localName,
    required super.distanceMeters,
    required super.walkMinutes,
    required super.alertLeadMinutes,
    required super.alertsEnabled,
    required super.isSaved,
    required super.arrivals,
  });

  factory StopArrivalsModel.fromJson(Map<String, dynamic> json) {
    return StopArrivalsModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      localName: json['name_local'] as String? ?? '',
      distanceMeters: json['distance_meters'] as int,
      walkMinutes: json['walk_minutes'] as int,
      alertLeadMinutes: json['alert_lead_minutes'] as int? ?? 5,
      alertsEnabled: json['alerts_enabled'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
      arrivals:
          (json['arrivals'] as List<dynamic>)
              .map<Arrival>(
                (e) => ArrivalModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class ArrivalModel extends Arrival {
  const ArrivalModel({
    required super.busId,
    required super.busNumber,
    required super.destination,
    required super.routeName,
    required super.etaMinutes,
  });

  factory ArrivalModel.fromJson(Map<String, dynamic> json) {
    return ArrivalModel(
      busId: json['bus_id'].toString(),
      busNumber: json['bus_number'].toString(),
      destination: json['destination'] as String? ?? '',
      routeName: json['route_name'] as String? ?? '',
      etaMinutes: json['eta_minutes'] as int,
    );
  }
}
