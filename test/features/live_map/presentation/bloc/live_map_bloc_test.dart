import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrack/core/error/failures.dart';
import 'package:gotrack/core/map/map_point.dart';
import 'package:gotrack/core/usecase/usecase.dart';
import 'package:gotrack/features/live_map/domain/entities/live_map.dart';
import 'package:gotrack/features/live_map/domain/usecases/get_live_map.dart';
import 'package:gotrack/features/live_map/presentation/bloc/live_map_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLiveMap extends Mock implements GetLiveMap {}

void main() {
  late MockGetLiveMap getLiveMap;

  const map = LiveMap(
    updatedSecondsAgo: 5,
    userLocation: MapPoint(0.5, 0.5),
    routes: [
      BusRoute(id: 'a', name: 'Route A', path: [], stops: []),
      BusRoute(id: 'b', name: 'Route B', path: [], stops: []),
    ],
    buses: [],
  );

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() => getLiveMap = MockGetLiveMap());

  LiveMapBloc build() => LiveMapBloc(getLiveMap: getLiveMap);

  blocTest<LiveMapBloc, LiveMapState>(
    'loads the map and selects the first route',
    setUp: () {
      when(() => getLiveMap(any())).thenAnswer((_) async => const Right(map));
    },
    build: build,
    act: (bloc) => bloc.add(const LiveMapStarted()),
    expect:
        () => const [
          LiveMapLoading(),
          LiveMapLoaded(map: map, selectedRouteId: 'a'),
        ],
  );

  blocTest<LiveMapBloc, LiveMapState>(
    'emits an error when loading fails',
    setUp: () {
      when(
        () => getLiveMap(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));
    },
    build: build,
    act: (bloc) => bloc.add(const LiveMapStarted()),
    expect: () => const [LiveMapLoading(), LiveMapError('boom')],
  );

  blocTest<LiveMapBloc, LiveMapState>(
    'changes the selected route, null meaning all routes',
    build: build,
    seed: () => const LiveMapLoaded(map: map, selectedRouteId: 'a'),
    act:
        (bloc) =>
            bloc
              ..add(const LiveMapRouteSelected('b'))
              ..add(const LiveMapRouteSelected(null)),
    expect:
        () => const [
          LiveMapLoaded(map: map, selectedRouteId: 'b'),
          LiveMapLoaded(map: map, selectedRouteId: null),
        ],
  );
}
