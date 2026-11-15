import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/stop_arrivals.dart';
import '../repositories/stops_repository.dart';

class GetStopArrivals implements UseCase<StopArrivals, StopArrivalsParams> {
  const GetStopArrivals(this._repository);

  final StopsRepository _repository;

  @override
  Future<Either<Failure, StopArrivals>> call(StopArrivalsParams params) {
    return _repository.getStopArrivals(params.stopId);
  }
}

class StopArrivalsParams extends Equatable {
  const StopArrivalsParams(this.stopId);

  final String stopId;

  @override
  List<Object?> get props => [stopId];
}
