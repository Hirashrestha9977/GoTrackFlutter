import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrack/core/error/failures.dart';
import 'package:gotrack/core/usecase/usecase.dart';
import 'package:gotrack/features/my_location/domain/entities/location_trail.dart';
import 'package:gotrack/features/my_location/domain/usecases/get_location_trail.dart';
import 'package:gotrack/features/my_location/presentation/bloc/my_location_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLocationTrail extends Mock implements GetLocationTrail {}

void main() {
  late MockGetLocationTrail getLocationTrail;

  const trail = LocationTrail(
    updatedSecondsAgo: 12,
    points: [
      LocationPoint(latitude: 27.66, longitude: 85.32, place: 'A'),
      LocationPoint(latitude: 27.68, longitude: 85.31, place: 'B'),
      LocationPoint(latitude: 27.70, longitude: 85.31, place: 'C'),
    ],
  );

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() => getLocationTrail = MockGetLocationTrail());

  MyLocationBloc build() => MyLocationBloc(getLocationTrail: getLocationTrail);

  test('lastPoint is the final entry, or null when empty', () {
    expect(trail.lastPoint?.place, 'C');
    expect(
      const LocationTrail(updatedSecondsAgo: 0, points: []).lastPoint,
      isNull,
    );
  });

  blocTest<MyLocationBloc, MyLocationState>(
    'loads the location trail',
    setUp: () {
      when(
        () => getLocationTrail(any()),
      ).thenAnswer((_) async => const Right(trail));
    },
    build: build,
    act: (bloc) => bloc.add(const MyLocationStarted()),
    expect: () => const [MyLocationLoading(), MyLocationLoaded(trail)],
  );

  blocTest<MyLocationBloc, MyLocationState>(
    'emits an error when loading fails',
    setUp: () {
      when(
        () => getLocationTrail(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));
    },
    build: build,
    act: (bloc) => bloc.add(const MyLocationStarted()),
    expect: () => const [MyLocationLoading(), MyLocationError('boom')],
  );

  blocTest<MyLocationBloc, MyLocationState>(
    'opens, switches and closes point details, ignoring unknown points',
    build: build,
    seed: () => const MyLocationLoaded(trail),
    act:
        (bloc) =>
            bloc
              ..add(const MyLocationPointSelected(1))
              ..add(const MyLocationPointSelected(99))
              ..add(const MyLocationPointSelected(2))
              ..add(const MyLocationPointSelected(null)),
    expect:
        () => const [
          MyLocationLoaded(trail, selectedIndex: 1),
          MyLocationLoaded(trail, selectedIndex: 2),
          MyLocationLoaded(trail),
        ],
  );
}
