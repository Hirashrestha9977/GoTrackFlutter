import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/live_map.dart';
import '../../domain/repositories/live_map_repository.dart';
import '../datasources/live_map_data_source.dart';

/// Converts data-source exceptions into [Failure]s.
///
/// There is no connectivity check yet because the data is bundled with the
/// app. Add `NetworkInfo` here (as in `AuthRepositoryImpl`) when the data
/// source goes remote.
class LiveMapRepositoryImpl implements LiveMapRepository {
  const LiveMapRepositoryImpl(this._dataSource);

  final LiveMapDataSource _dataSource;

  @override
  Future<Either<Failure, LiveMap>> getLiveMap() async {
    try {
      return Right(await _dataSource.getLiveMap());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
