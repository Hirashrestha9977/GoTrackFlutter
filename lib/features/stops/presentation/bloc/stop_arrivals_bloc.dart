import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stop_arrivals.dart';
import '../../domain/usecases/get_stop_arrivals.dart';

part 'stop_arrivals_event.dart';
part 'stop_arrivals_state.dart';

class StopArrivalsBloc extends Bloc<StopArrivalsEvent, StopArrivalsState> {
  StopArrivalsBloc({required GetStopArrivals getStopArrivals})
    : _getStopArrivals = getStopArrivals,
      super(const StopArrivalsInitial()) {
    on<StopArrivalsStarted>(_onStarted);
    on<StopArrivalsAlertsToggled>(_onAlertsToggled);
    on<StopArrivalsSaveToggled>(_onSaveToggled);
  }

  final GetStopArrivals _getStopArrivals;

  Future<void> _onStarted(
    StopArrivalsStarted event,
    Emitter<StopArrivalsState> emit,
  ) async {
    emit(const StopArrivalsLoading());
    final result = await _getStopArrivals(StopArrivalsParams(event.stopId));
    emit(
      result.fold(
        (failure) => StopArrivalsError(failure.message),
        (stop) => StopArrivalsLoaded(
          stop: stop,
          alertsEnabled: stop.alertsEnabled,
          isSaved: stop.isSaved,
        ),
      ),
    );
  }

  void _onAlertsToggled(
    StopArrivalsAlertsToggled event,
    Emitter<StopArrivalsState> emit,
  ) {
    final current = state;
    if (current is! StopArrivalsLoaded) return;
    emit(current.copyWith(alertsEnabled: !current.alertsEnabled));
  }

  void _onSaveToggled(
    StopArrivalsSaveToggled event,
    Emitter<StopArrivalsState> emit,
  ) {
    final current = state;
    if (current is! StopArrivalsLoaded) return;
    emit(current.copyWith(isSaved: !current.isSaved));
  }
}
