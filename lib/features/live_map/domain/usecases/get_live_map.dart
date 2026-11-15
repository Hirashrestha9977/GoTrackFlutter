import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/live_map.dart';
import '../repositories/live_map_repository.dart';

class GetLiveMap implements UseCase<LiveMap, NoParams> {
  const GetLiveMap(this._repository);

  final LiveMapRepository _repository;

  @override
  Future<Either<Failure, LiveMap>> call(NoParams params) {
    return _repository.getLiveMap();
  }
}
