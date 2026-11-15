part of 'bus_tracking_bloc.dart';

sealed class BusTrackingEvent extends Equatable {
  const BusTrackingEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) tracking data for one bus.
final class BusTrackingStarted extends BusTrackingEvent {
  const BusTrackingStarted(this.busId);

  final String busId;

  @override
  List<Object?> get props => [busId];
}

/// "Alert me 1 stop before" was tapped.
final class BusTrackingAlertToggled extends BusTrackingEvent {
  const BusTrackingAlertToggled();
}
