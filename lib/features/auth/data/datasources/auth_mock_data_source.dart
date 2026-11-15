import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Dummy login used until the auth API is ready: any email and any
/// non-empty password signs in. Nothing is sent over the network.
///
/// To go live, register [AuthRemoteDataSourceImpl] in
/// `injection_container.dart` instead of this class and delete this file.
class AuthMockDataSource implements AuthRemoteDataSource {
  const AuthMockDataSource({this.delay = const Duration(milliseconds: 600)});

  /// Simulated network latency so the loading state is visible.
  final Duration delay;

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);

    // "hira.shrestha@mail.com" -> "Hira Shrestha"
    final name = email
        .split('@')
        .first
        .split(RegExp(r'[._\-+]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');

    return (
      token: 'mock-token',
      user: UserModel(id: '1', name: name, email: email),
    );
  }

  @override
  Future<void> logout() async {}
}
