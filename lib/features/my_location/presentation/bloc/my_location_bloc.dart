import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/location_trail.dart';
import '../../domain/usecases/get_location_trail.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc({required GetLocationTrail getLocationTrail})
    : _getLocationTrail = getLocationTrail,
      super(const MyLocationInitial()) {
    on<MyLocationStarted>(_onStarted);
    on<MyLocationPointSelected>(_onPointSelected);
  }

  final GetLocationTrail _getLocationTrail;

  Future<void> _onStarted(
    MyLocationStarted event,
    Emitter<MyLocationState> emit,
  ) async {
    emit(const MyLocationLoading());
    final result = await _getLocationTrail(const NoParams());
    emit(
      result.fold(
        (failure) => MyLocationError(failure.message),
        (trail) => MyLocationLoaded(trail),
      ),
    );
  }

  void _onPointSelected(
    MyLocationPointSelected event,
    Emitter<MyLocationState> emit,
  ) {
    final current = state;
    if (current is! MyLocationLoaded) return;

    final index = event.index;
    final isValid =
        index == null || (index >= 0 && index < current.trail.points.length);
    if (!isValid) return;
    emit(MyLocationLoaded(current.trail, selectedIndex: index));
  }
}
