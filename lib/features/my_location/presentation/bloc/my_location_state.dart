part of 'my_location_bloc.dart';

sealed class MyLocationState extends Equatable {
  const MyLocationState();

  @override
  List<Object?> get props => [];
}

final class MyLocationInitial extends MyLocationState {
  const MyLocationInitial();
}

final class MyLocationLoading extends MyLocationState {
  const MyLocationLoading();
}

final class MyLocationLoaded extends MyLocationState {
  const MyLocationLoaded(this.trail, {this.selectedIndex});

  final LocationTrail trail;

  /// Index of the point whose details are open; `null` when none is.
  final int? selectedIndex;

  @override
  List<Object?> get props => [trail, selectedIndex];
}

final class MyLocationError extends MyLocationState {
  const MyLocationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
