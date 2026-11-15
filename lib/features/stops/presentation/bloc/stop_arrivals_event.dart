part of 'stop_arrivals_bloc.dart';

sealed class StopArrivalsEvent extends Equatable {
  const StopArrivalsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) arrivals for one stop.
final class StopArrivalsStarted extends StopArrivalsEvent {
  const StopArrivalsStarted(this.stopId);

  final String stopId;

  @override
  List<Object?> get props => [stopId];
}

/// The "Arrival alerts" checkbox was tapped.
final class StopArrivalsAlertsToggled extends StopArrivalsEvent {
  const StopArrivalsAlertsToggled();
}

/// The bookmark button was tapped.
final class StopArrivalsSaveToggled extends StopArrivalsEvent {
  const StopArrivalsSaveToggled();
}
