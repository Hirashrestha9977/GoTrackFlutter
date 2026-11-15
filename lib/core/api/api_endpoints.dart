/// All API paths live here so no feature hard-codes a URL.
class ApiEndpoints {
  ApiEndpoints._();

  /// Override at build time:
  /// `flutter run --dart-define=BASE_URL=https://api.yourdomain.com/v1`
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
}
