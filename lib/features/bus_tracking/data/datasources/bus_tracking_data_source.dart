import '../../../../core/error/exceptions.dart';
import '../../../../core/mock/mock_assets.dart';
import '../../../../core/mock/mock_json_loader.dart';
import '../models/bus_tracking_model.dart';

abstract interface class BusTrackingDataSource {
  /// Throws [ServerException], [UnauthorizedException] or [NetworkException].
  Future<BusTrackingModel> getBusTracking(String busId);
}

/// Serves `assets/mock/bus_tracking.json`, which holds one entry per bus.
///
/// When the API is ready, add a `BusTrackingRemoteDataSource` that calls
/// `ApiClient.get(...)` and register it in `injection_container.dart`
/// instead of this class. Nothing else needs to change.
class BusTrackingMockDataSource implements BusTrackingDataSource {
  const BusTrackingMockDataSource(this._loader);

  final MockJsonLoader _loader;

  @override
  Future<BusTrackingModel> getBusTracking(String busId) async {
    final json = await _loader.load(MockAssets.busTracking);

    final List<BusTrackingModel> buses;
    try {
      buses =
          (json['buses'] as List<dynamic>)
              .map((e) => BusTrackingModel.fromJson(e as Map<String, dynamic>))
              .toList();
    } catch (_) {
      throw const ServerException('Unexpected bus tracking response');
    }

    for (final bus in buses) {
      if (bus.busId == busId) return bus;
    }
    throw ServerException('Bus $busId is not available', statusCode: 404);
  }
}
