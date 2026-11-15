class AppConstants {
  AppConstants._();

  static const String appName = 'Gotrack';

  // Local storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'cached_user';

  /// Stop shown on the Stops tab until the nearest stop comes from the API.
  static const String defaultStopId = 'jamal';
}
