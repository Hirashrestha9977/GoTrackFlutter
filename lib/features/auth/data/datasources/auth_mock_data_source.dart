import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Dummy login used until the auth API is ready. Nothing is sent over the
/// network.
///
/// * [ownerEmail] with [ownerPassword] signs in as an owner.
/// * Any other email with any non-empty password signs in as a general user.
///
/// To go live, register [AuthRemoteDataSourceImpl] in
/// `injection_container.dart` instead of this class and delete this file.
class AuthMockDataSource implements AuthRemoteDataSource {
  const AuthMockDataSource({this.delay = const Duration(milliseconds: 600)});

  /// Test account for the owner experience.
  static const String ownerEmail = 'hira@gmail.com';
  static const String ownerPassword = '123456';

  /// Simulated network latency so the loading state is visible.
  final Duration delay;

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);

    final isOwner = email.trim().toLowerCase() == ownerEmail;
    if (isOwner && password != ownerPassword) {
      throw const UnauthorizedException('Incorrect email or password');
    }

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
      user: UserModel(
        id: isOwner ? 'owner-1' : '1',
        name: name,
        email: email,
        userType: isOwner ? UserType.owner : UserType.generalUser,
      ),
    );
  }

  @override
  Future<void> logout() async {}
}
