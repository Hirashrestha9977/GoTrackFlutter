import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Contract the domain layer depends on. Implemented in the data layer.
abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  /// Returns the signed-in user from local storage, or `null` if none.
  Future<Either<Failure, User?>> getCachedUser();
}
