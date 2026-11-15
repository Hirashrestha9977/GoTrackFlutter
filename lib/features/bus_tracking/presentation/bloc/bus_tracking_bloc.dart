import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bus_tracking.dart';
import '../../domain/usecases/get_bus_tracking.dart';

part 'bus_tracking_event.dart';
part 'bus_tracking_state.dart';

class BusTrackingBloc extends Bloc<BusTrackingEvent, BusTrackingState> {
  BusTrackingBloc({required GetBusTracking getBusTracking})
    : _getBusTracking = getBusTracking,
      super(const BusTrackingInitial()) {
    on<BusTrackingStarted>(_onStarted);
    on<BusTrackingAlertToggled>(_onAlertToggled);
  }

  final GetBusTracking _getBusTracking;

  Future<void> _onStarted(
    BusTrackingStarted event,
    Emitter<BusTrackingState> emit,
  ) async {
    emit(const BusTrackingLoading());
    final result = await _getBusTracking(BusTrackingParams(event.busId));
    emit(
      result.fold(
        (failure) => BusTrackingError(failure.message),
        (tracking) => BusTrackingLoaded(tracking: tracking),
      ),
    );
  }

  void _onAlertToggled(
    BusTrackingAlertToggled event,
    Emitter<BusTrackingState> emit,
  ) {
    final current = state;
    if (current is! BusTrackingLoaded) return;
    emit(
      BusTrackingLoaded(
        tracking: current.tracking,
        alertEnabled: !current.alertEnabled,
      ),
    );
  }
}
