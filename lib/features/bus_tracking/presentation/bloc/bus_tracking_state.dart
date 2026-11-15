part of 'bus_tracking_bloc.dart';

sealed class BusTrackingState extends Equatable {
  const BusTrackingState();

  @override
  List<Object?> get props => [];
}

final class BusTrackingInitial extends BusTrackingState {
  const BusTrackingInitial();
}

final class BusTrackingLoading extends BusTrackingState {
  const BusTrackingLoading();
}

final class BusTrackingLoaded extends BusTrackingState {
  const BusTrackingLoaded({required this.tracking, this.alertEnabled = false});

  final BusTracking tracking;

  /// Local only for now; send to the API when alerts are supported.
  final bool alertEnabled;

  @override
  List<Object?> get props => [tracking, alertEnabled];
}

final class BusTrackingError extends BusTrackingState {
  const BusTrackingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
