import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUser implements UseCase<User?, NoParams> {
  const GetCachedUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return _repository.getCachedUser();
  }
}
