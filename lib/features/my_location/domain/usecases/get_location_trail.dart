import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/location_trail.dart';
import '../repositories/my_location_repository.dart';

class GetLocationTrail implements UseCase<LocationTrail, NoParams> {
  const GetLocationTrail(this._repository);

  final MyLocationRepository _repository;

  @override
  Future<Either<Failure, LocationTrail>> call(NoParams params) {
    return _repository.getLocationTrail();
  }
}
