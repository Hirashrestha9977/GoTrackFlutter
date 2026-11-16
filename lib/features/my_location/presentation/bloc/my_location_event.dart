part of 'my_location_bloc.dart';

sealed class MyLocationEvent extends Equatable {
  const MyLocationEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) the location trail.
final class MyLocationStarted extends MyLocationEvent {
  const MyLocationStarted();
}

/// A point on the trail was tapped. `null` closes the details.
final class MyLocationPointSelected extends MyLocationEvent {
  const MyLocationPointSelected(this.index);

  /// Position of the point in `LocationTrail.points`.
  final int? index;

  @override
  List<Object?> get props => [index];
}
