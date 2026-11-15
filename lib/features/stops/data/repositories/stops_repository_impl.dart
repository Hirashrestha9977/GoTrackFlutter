import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/stop_arrivals.dart';
import '../../domain/repositories/stops_repository.dart';
import '../datasources/stops_data_source.dart';

/// Converts data-source exceptions into [Failure]s.
///
/// There is no connectivity check yet because the data is bundled with the
/// app. Add `NetworkInfo` here (as in `AuthRepositoryImpl`) when the data
/// source goes remote.
class StopsRepositoryImpl implements StopsRepository {
  const StopsRepositoryImpl(this._dataSource);

  final StopsDataSource _dataSource;

  @override
  Future<Either<Failure, StopArrivals>> getStopArrivals(String stopId) async {
    try {
      return Right(await _dataSource.getStopArrivals(stopId));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
