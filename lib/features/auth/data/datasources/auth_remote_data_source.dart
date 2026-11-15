import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

typedef LoginResponse = ({String token, UserModel user});

abstract interface class AuthRemoteDataSource {
  /// Throws [ServerException], [UnauthorizedException] or [NetworkException].
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Expects a response shaped like:
  /// `{ "token": "...", "user": { "id": 1, "name": "...", "email": "..." } }`
  /// Adjust the parsing here to match the real backend.
  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );

    if (data is! Map<String, dynamic> ||
        data['token'] is! String ||
        data['user'] is! Map<String, dynamic>) {
      throw const ServerException('Unexpected login response');
    }

    return (
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  @override
  Future<void> logout() async {
    await _client.post(ApiEndpoints.logout);
  }
}
