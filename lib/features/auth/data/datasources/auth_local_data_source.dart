import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  String? get token;

  /// Throws [CacheException] if the stored user is corrupt.
  UserModel? getUser();

  Future<void> saveSession({required String token, required UserModel user});

  Future<void> clear();
}

/// Stores the session in SharedPreferences. For production, consider moving
/// the token to `flutter_secure_storage` (Keychain / Keystore).
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? get token => _prefs.getString(AppConstants.tokenKey);

  @override
  UserModel? getUser() {
    final raw = _prefs.getString(AppConstants.userKey);
    if (raw == null || token == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      throw const CacheException('Stored session is corrupt');
    }
  }

  @override
  Future<void> saveSession({
    required String token,
    required UserModel user,
  }) async {
    await _prefs.setString(AppConstants.tokenKey, token);
    await _prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userKey);
  }
}
