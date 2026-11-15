part of 'stop_arrivals_bloc.dart';

sealed class StopArrivalsState extends Equatable {
  const StopArrivalsState();

  @override
  List<Object?> get props => [];
}

final class StopArrivalsInitial extends StopArrivalsState {
  const StopArrivalsInitial();
}

final class StopArrivalsLoading extends StopArrivalsState {
  const StopArrivalsLoading();
}

final class StopArrivalsLoaded extends StopArrivalsState {
  const StopArrivalsLoaded({
    required this.stop,
    required this.alertsEnabled,
    required this.isSaved,
  });

  final StopArrivals stop;

  // Local only for now; send to the API when these are supported.
  final bool alertsEnabled;
  final bool isSaved;

  StopArrivalsLoaded copyWith({bool? alertsEnabled, bool? isSaved}) {
    return StopArrivalsLoaded(
      stop: stop,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [stop, alertsEnabled, isSaved];
}

final class StopArrivalsError extends StopArrivalsState {
  const StopArrivalsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
