import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/stop_arrivals.dart';

/// Contract the domain layer depends on. Implemented in the data layer.
abstract interface class StopsRepository {
  Future<Either<Failure, StopArrivals>> getStopArrivals(String stopId);
}
