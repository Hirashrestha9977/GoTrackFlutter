import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/bus_tracking/presentation/bloc/bus_tracking_bloc.dart';
import '../../features/bus_tracking/presentation/pages/bus_tracking_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/live_map/presentation/bloc/live_map_bloc.dart';
import '../../features/live_map/presentation/pages/live_map_page.dart';
import '../../features/my_location/presentation/bloc/my_location_bloc.dart';
import '../../features/my_location/presentation/pages/my_location_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/routes/presentation/pages/routes_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/stops/presentation/bloc/stop_arrivals_bloc.dart';
import '../../features/stops/presentation/pages/stop_arrivals_page.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';
import 'route_names.dart';

/// All routes are declared here. The router listens to [AuthBloc] and
/// redirects between splash / login / the signed-in tabs as the auth
/// state changes.
class AppRouter {
  AppRouter(this._authBloc);

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: _StreamListenable(_authBloc.stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // Signed-in area: one branch per bottom tab, in tab order.
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                HomeShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.liveMap,
                name: RouteNames.liveMap,
                builder:
                    (context, state) => BlocProvider(
                      create:
                          (_) => sl<LiveMapBloc>()..add(const LiveMapStarted()),
                      child: const LiveMapPage(),
                    ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.routes,
                name: RouteNames.routes,
                builder: (context, state) => const RoutesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.stops,
                name: RouteNames.stops,
                builder: (context, state) {
                  // Until there is a stop list / nearest-stop lookup, the
                  // tab opens the default stop.
                  const stopId = AppConstants.defaultStopId;
                  return BlocProvider(
                    create:
                        (_) =>
                            sl<StopArrivalsBloc>()
                              ..add(const StopArrivalsStarted(stopId)),
                    child: const StopArrivalsPage(stopId: stopId),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          // Owner-only. Kept last so the indices above stay stable;
          // `HomeShellPage` decides which branches each user type sees.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.myLocation,
                name: RouteNames.myLocation,
                builder:
                    (context, state) => BlocProvider(
                      create:
                          (_) =>
                              sl<MyLocationBloc>()
                                ..add(const MyLocationStarted()),
                      child: const MyLocationPage(),
                    ),
              ),
            ],
          ),
        ],
      ),

      // Full-screen, opened on top of the tabs.
      GoRoute(
        path: RoutePaths.busTracking,
        name: RouteNames.busTracking,
        builder: (context, state) {
          final busId = state.pathParameters['busId']!;
          return BlocProvider(
            create:
                (_) => sl<BusTrackingBloc>()..add(BusTrackingStarted(busId)),
            child: BusTrackingPage(busId: busId),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Page not found: ${state.uri.path}')),
        ),
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final onPublicPage =
        location == RoutePaths.splash || location == RoutePaths.login;

    return switch (_authBloc.state) {
      AuthInitial() => RoutePaths.splash,
      AuthLoading() => null,
      Authenticated(:final user) => _signedInRedirect(
        location,
        isOwner: user.userType == UserType.owner,
        onPublicPage: onPublicPage,
      ),
      Unauthenticated() ||
      AuthError() => location == RoutePaths.login ? null : RoutePaths.login,
    };
  }

  /// Sends a signed-in user to their landing tab, and keeps each user type
  /// out of the tabs it does not have.
  String? _signedInRedirect(
    String location, {
    required bool isOwner,
    required bool onPublicPage,
  }) {
    if (isOwner) {
      final blocked = RoutePaths.nonOwnerTabs.contains(location);
      return onPublicPage || blocked ? RoutePaths.ownerHome : null;
    }
    final blocked = location == RoutePaths.myLocation;
    return onPublicPage || blocked ? RoutePaths.home : null;
  }
}

/// Bridges a bloc stream to the [Listenable] GoRouter expects.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
