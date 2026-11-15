import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/live_map.dart';
import '../../domain/usecases/get_live_map.dart';

part 'live_map_event.dart';
part 'live_map_state.dart';

class LiveMapBloc extends Bloc<LiveMapEvent, LiveMapState> {
  LiveMapBloc({required GetLiveMap getLiveMap})
    : _getLiveMap = getLiveMap,
      super(const LiveMapInitial()) {
    on<LiveMapStarted>(_onStarted);
    on<LiveMapRouteSelected>(_onRouteSelected);
  }

  final GetLiveMap _getLiveMap;

  Future<void> _onStarted(
    LiveMapStarted event,
    Emitter<LiveMapState> emit,
  ) async {
    emit(const LiveMapLoading());
    final result = await _getLiveMap(const NoParams());
    emit(
      result.fold(
        (failure) => LiveMapError(failure.message),
        (map) => LiveMapLoaded(
          map: map,
          selectedRouteId: map.routes.isEmpty ? null : map.routes.first.id,
        ),
      ),
    );
  }

  void _onRouteSelected(
    LiveMapRouteSelected event,
    Emitter<LiveMapState> emit,
  ) {
    final current = state;
    if (current is! LiveMapLoaded) return;
    emit(LiveMapLoaded(map: current.map, selectedRouteId: event.routeId));
  }
}
