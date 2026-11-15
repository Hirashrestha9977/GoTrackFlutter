import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Coordinates remote + local data sources and converts exceptions
/// into [Failure]s so nothing above the data layer has to catch.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required NetworkInfo networkInfo,
  }) : _remote = remote,
       _local = local,
       _networkInfo = networkInfo;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final result = await _remote.login(email: email, password: password);
      await _local.saveSession(token: result.token, user: result.user);
      return Right(result.user);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // The local session is always cleared, even if the server call fails,
    // so the user is never stuck signed in.
    try {
      await _remote.logout();
    } on Exception {
      // Ignored on purpose: see comment above.
    }
    await _local.clear();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      return Right(_local.getUser());
    } on CacheException catch (e) {
      await _local.clear();
      return Left(CacheFailure(e.message));
    }
  }
}
