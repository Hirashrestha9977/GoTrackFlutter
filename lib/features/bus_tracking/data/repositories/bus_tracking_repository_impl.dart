import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/bus_tracking.dart';
import '../../domain/repositories/bus_tracking_repository.dart';
import '../datasources/bus_tracking_data_source.dart';

/// Converts data-source exceptions into [Failure]s.
///
/// There is no connectivity check yet because the data is bundled with the
/// app. Add `NetworkInfo` here (as in `AuthRepositoryImpl`) when the data
/// source goes remote.
class BusTrackingRepositoryImpl implements BusTrackingRepository {
  const BusTrackingRepositoryImpl(this._dataSource);

  final BusTrackingDataSource _dataSource;

  @override
  Future<Either<Failure, BusTracking>> getBusTracking(String busId) async {
    try {
      return Right(await _dataSource.getBusTracking(busId));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
