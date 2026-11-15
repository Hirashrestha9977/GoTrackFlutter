part of 'live_map_bloc.dart';

sealed class LiveMapState extends Equatable {
  const LiveMapState();

  @override
  List<Object?> get props => [];
}

final class LiveMapInitial extends LiveMapState {
  const LiveMapInitial();
}

final class LiveMapLoading extends LiveMapState {
  const LiveMapLoading();
}

final class LiveMapLoaded extends LiveMapState {
  const LiveMapLoaded({required this.map, required this.selectedRouteId});

  final LiveMap map;

  /// `null` means "All routes".
  final String? selectedRouteId;

  /// Whether [bus] belongs to the selected route (always true for "All").
  bool isOnSelectedRoute(NearbyBus bus) {
    return selectedRouteId == null || bus.routeId == selectedRouteId;
  }

  @override
  List<Object?> get props => [map, selectedRouteId];
}

final class LiveMapError extends LiveMapState {
  const LiveMapError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
