import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/location_trail.dart';
import '../../domain/repositories/my_location_repository.dart';
import '../datasources/my_location_data_source.dart';

/// Converts data-source exceptions into [Failure]s.
///
/// There is no connectivity check yet because the data is bundled with the
/// app. Add `NetworkInfo` here (as in `AuthRepositoryImpl`) when the data
/// source goes remote.
class MyLocationRepositoryImpl implements MyLocationRepository {
  const MyLocationRepositoryImpl(this._dataSource);

  final MyLocationDataSource _dataSource;

  @override
  Future<Either<Failure, LocationTrail>> getLocationTrail() async {
    try {
      return Right(await _dataSource.getLocationTrail());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
