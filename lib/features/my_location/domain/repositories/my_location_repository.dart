import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/location_trail.dart';

/// Contract the domain layer depends on. Implemented in the data layer.
abstract interface class MyLocationRepository {
  Future<Either<Failure, LocationTrail>> getLocationTrail();
}
