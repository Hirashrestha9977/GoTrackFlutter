/// Exceptions are thrown by the data layer (data sources) and converted to
/// [Failure]s inside repository implementations.
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);

  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
