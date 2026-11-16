import 'package:flutter_test/flutter_test.dart';
import 'package:gotrack/core/error/exceptions.dart';
import 'package:gotrack/core/mock/mock_json_loader.dart';
import 'package:gotrack/features/bus_tracking/data/datasources/bus_tracking_data_source.dart';
import 'package:gotrack/features/live_map/data/datasources/live_map_data_source.dart';
import 'package:gotrack/features/my_location/data/datasources/my_location_data_source.dart';
import 'package:gotrack/features/stops/data/datasources/stops_data_source.dart';

/// Guards the bundled JSON: every file must parse through its model.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const loader = MockJsonLoader(delay: Duration.zero);

  test('live_map.json parses and every bus is on a known route', () async {
    final map = await const LiveMapMockDataSource(loader).getLiveMap();

    expect(map.routes, isNotEmpty);
    expect(map.buses, isNotEmpty);
    final routeIds = map.routes.map((route) => route.id).toSet();
    for (final bus in map.buses) {
      expect(routeIds, contains(bus.routeId));
    }
  });

  test(
    'bus_tracking.json has an entry for every bus the UI links to',
    () async {
      const dataSource = BusTrackingMockDataSource(loader);
      final map = await const LiveMapMockDataSource(loader).getLiveMap();
      final stop = await const StopsMockDataSource(
        loader,
      ).getStopArrivals('jamal');

      final busIds = {
        ...map.buses.map((bus) => bus.id),
        ...stop.arrivals.map((arrival) => arrival.busId),
      };
      for (final busId in busIds) {
        final tracking = await dataSource.getBusTracking(busId);
        expect(tracking.busId, busId);
        expect(tracking.stops, isNotEmpty);
        expect(tracking.userStop, isNotNull);
      }
    },
  );

  test('my_location.json parses into a trail with a last point', () async {
    final trail =
        await const MyLocationMockDataSource(loader).getLocationTrail();

    expect(trail.points.length, greaterThan(1));
    expect(trail.lastPoint, trail.points.last);
    for (final point in trail.points) {
      expect(point.latitude, inInclusiveRange(-90, 90));
      expect(point.longitude, inInclusiveRange(-180, 180));
      expect(point.place, isNotEmpty);
      expect(point.recordedAt, isNotNull);
      expect(point.speedKmh, isNotNull);
    }
  });

  test('unknown ids throw ServerException', () async {
    expect(
      () => const BusTrackingMockDataSource(loader).getBusTracking('nope'),
      throwsA(isA<ServerException>()),
    );
    expect(
      () => const StopsMockDataSource(loader).getStopArrivals('nope'),
      throwsA(isA<ServerException>()),
    );
  });
}
