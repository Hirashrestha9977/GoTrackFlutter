import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/live_map.dart';
import '../bloc/live_map_bloc.dart';
import '../widgets/live_map_view.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/nearby_buses_sheet.dart';

class LiveMapPage extends StatelessWidget {
  const LiveMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.palette.mapBackground,
        body: BlocBuilder<LiveMapBloc, LiveMapState>(
          builder: (context, state) {
            return switch (state) {
              LiveMapInitial() || LiveMapLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              LiveMapError(:final message) => ErrorView(
                message: message,
                onRetry:
                    () =>
                        context.read<LiveMapBloc>().add(const LiveMapStarted()),
              ),
              LiveMapLoaded() => _LiveMapBody(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _LiveMapBody extends StatelessWidget {
  const _LiveMapBody({required this.state});

  final LiveMapLoaded state;

  void _trackBus(BuildContext context, NearbyBus bus) {
    context.pushNamed(
      RouteNames.busTracking,
      pathParameters: {'busId': bus.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final map = state.map;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: LiveMapView(
                  map: map,
                  selectedRouteId: state.selectedRouteId,
                  onBusTap: (bus) => _trackBus(context, bus),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: MapSearchBar(
                        onSearchTap: () => showComingSoon(context, 'Search'),
                        onLanguageTap:
                            () => showComingSoon(context, 'Nepali language'),
                      ),
                    ),
                    RouteChips(
                      routes: {
                        for (final route in map.routes) route.id: route.name,
                      },
                      selectedRouteId: state.selectedRouteId,
                      onSelected:
                          (routeId) => context.read<LiveMapBloc>().add(
                            LiveMapRouteSelected(routeId),
                          ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 44),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundIconButton(
                              icon: Icons.layers_outlined,
                              tooltip: 'Map layers',
                              onTap:
                                  () => showComingSoon(context, 'Map layers'),
                            ),
                            const SizedBox(height: 12),
                            RoundIconButton(
                              icon: Icons.my_location,
                              tooltip: 'My location',
                              foreground: palette.primaryText,
                              onTap:
                                  () => showComingSoon(context, 'My location'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Pulled up over the map so its rounded corners sit on top of it.
        // The surface-coloured box fills the strip the shift leaves behind.
        ColoredBox(
          color: palette.surface,
          child: Transform.translate(
            offset: const Offset(0, -NearbyBusesSheet.cornerRadius),
            child: NearbyBusesSheet(
              buses: map.buses,
              updatedSecondsAgo: map.updatedSecondsAgo,
              isEmphasized: state.isOnSelectedRoute,
              onBusTap: (bus) => _trackBus(context, bus),
            ),
          ),
        ),
      ],
    );
  }
}
