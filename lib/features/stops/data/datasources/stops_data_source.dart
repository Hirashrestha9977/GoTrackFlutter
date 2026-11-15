import '../../../../core/error/exceptions.dart';
import '../../../../core/mock/mock_assets.dart';
import '../../../../core/mock/mock_json_loader.dart';
import '../models/stop_arrivals_model.dart';

abstract interface class StopsDataSource {
  /// Throws [ServerException], [UnauthorizedException] or [NetworkException].
  Future<StopArrivalsModel> getStopArrivals(String stopId);
}

/// Serves `assets/mock/stop_arrivals.json`, which holds one entry per stop.
///
/// When the API is ready, add a `StopsRemoteDataSource` that calls
/// `ApiClient.get(...)` and register it in `injection_container.dart`
/// instead of this class. Nothing else needs to change.
class StopsMockDataSource implements StopsDataSource {
  const StopsMockDataSource(this._loader);

  final MockJsonLoader _loader;

  @override
  Future<StopArrivalsModel> getStopArrivals(String stopId) async {
    final json = await _loader.load(MockAssets.stopArrivals);

    final List<StopArrivalsModel> stops;
    try {
      stops =
          (json['stops'] as List<dynamic>)
              .map((e) => StopArrivalsModel.fromJson(e as Map<String, dynamic>))
              .toList();
    } catch (_) {
      throw const ServerException('Unexpected stop arrivals response');
    }

    for (final stop in stops) {
      if (stop.id == stopId) return stop;
    }
    throw ServerException('Stop $stopId is not available', statusCode: 404);
  }
}
