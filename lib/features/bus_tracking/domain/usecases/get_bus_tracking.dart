import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/bus_tracking.dart';
import '../repositories/bus_tracking_repository.dart';

class GetBusTracking implements UseCase<BusTracking, BusTrackingParams> {
  const GetBusTracking(this._repository);

  final BusTrackingRepository _repository;

  @override
  Future<Either<Failure, BusTracking>> call(BusTrackingParams params) {
    return _repository.getBusTracking(params.busId);
  }
}

class BusTrackingParams extends Equatable {
  const BusTrackingParams(this.busId);

  final String busId;

  @override
  List<Object?> get props => [busId];
}
