import '../../../../core/error/exceptions.dart';
import '../../../../core/mock/mock_assets.dart';
import '../../../../core/mock/mock_json_loader.dart';
import '../models/live_map_model.dart';

abstract interface class LiveMapDataSource {
  /// Throws [ServerException], [UnauthorizedException] or [NetworkException].
  Future<LiveMapModel> getLiveMap();
}

/// Serves `assets/mock/live_map.json`.
///
/// When the API is ready, add a `LiveMapRemoteDataSource` that calls
/// `ApiClient.get(...)` and register it in `injection_container.dart`
/// instead of this class. Nothing else needs to change.
class LiveMapMockDataSource implements LiveMapDataSource {
  const LiveMapMockDataSource(this._loader);

  final MockJsonLoader _loader;

  @override
  Future<LiveMapModel> getLiveMap() async {
    final json = await _loader.load(MockAssets.liveMap);
    try {
      return LiveMapModel.fromJson(json);
    } catch (_) {
      throw const ServerException('Unexpected live map response');
    }
  }
}
