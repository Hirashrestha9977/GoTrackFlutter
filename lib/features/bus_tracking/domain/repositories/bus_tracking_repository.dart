import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/bus_tracking.dart';

/// Contract the domain layer depends on. Implemented in the data layer.
abstract interface class BusTrackingRepository {
  Future<Either<Failure, BusTracking>> getBusTracking(String busId);
}
