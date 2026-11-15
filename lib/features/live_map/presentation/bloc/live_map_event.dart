part of 'live_map_bloc.dart';

sealed class LiveMapEvent extends Equatable {
  const LiveMapEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) the map data.
final class LiveMapStarted extends LiveMapEvent {
  const LiveMapStarted();
}

/// A route chip was tapped. `null` means "All routes".
final class LiveMapRouteSelected extends LiveMapEvent {
  const LiveMapRouteSelected(this.routeId);

  final String? routeId;

  @override
  List<Object?> get props => [routeId];
}
