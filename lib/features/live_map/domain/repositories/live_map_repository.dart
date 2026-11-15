import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/live_map.dart';

/// Contract the domain layer depends on. Implemented in the data layer.
abstract interface class LiveMapRepository {
  Future<Either<Failure, LiveMap>> getLiveMap();
}
