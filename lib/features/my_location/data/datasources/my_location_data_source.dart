import '../../../../core/error/exceptions.dart';
import '../../../../core/mock/mock_assets.dart';
import '../../../../core/mock/mock_json_loader.dart';
import '../models/location_trail_model.dart';

abstract interface class MyLocationDataSource {
  /// Throws [ServerException], [UnauthorizedException] or [NetworkException].
  Future<LocationTrailModel> getLocationTrail();
}

/// Serves `assets/mock/my_location.json`.
///
/// When the API is ready, add a `MyLocationRemoteDataSource` that calls
/// `ApiClient.get(...)` and register it in `injection_container.dart`
/// instead of this class. Nothing else needs to change.
class MyLocationMockDataSource implements MyLocationDataSource {
  const MyLocationMockDataSource(this._loader);

  final MockJsonLoader _loader;

  @override
  Future<LocationTrailModel> getLocationTrail() async {
    final json = await _loader.load(MockAssets.myLocation);
    try {
      return LocationTrailModel.fromJson(json);
    } catch (_) {
      throw const ServerException('Unexpected location response');
    }
  }
}
