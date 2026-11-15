/// Route names and paths. Navigate with `context.goNamed(RouteNames.liveMap)`.
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';

  // Tabs
  static const String liveMap = 'liveMap';
  static const String routes = 'routes';
  static const String stops = 'stops';
  static const String profile = 'profile';

  /// Needs a `busId` path parameter.
  static const String busTracking = 'busTracking';
}

class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';

  // Tabs
  static const String liveMap = '/live-map';
  static const String routes = '/routes';
  static const String stops = '/stops';
  static const String profile = '/profile';

  static const String busTracking = '/buses/:busId';

  /// Where a signed-in user lands.
  static const String home = liveMap;
}
