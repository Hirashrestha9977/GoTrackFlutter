import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/bus_tracking_bloc.dart';
import '../widgets/arrival_card.dart';
import '../widgets/route_progress_list.dart';
import '../widgets/tracking_map_view.dart';

class BusTrackingPage extends StatelessWidget {
  const BusTrackingPage({super.key, required this.busId});

  final String busId;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.liveMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: palette.mapBackground,
        body: Stack(
          children: [
            Positioned.fill(
              child: BlocBuilder<BusTrackingBloc, BusTrackingState>(
                builder: (context, state) {
                  return switch (state) {
                    BusTrackingInitial() || BusTrackingLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    BusTrackingError(:final message) => ErrorView(
                      message: message,
                      onRetry:
                          () => context.read<BusTrackingBloc>().add(
                            BusTrackingStarted(busId),
                          ),
                    ),
                    BusTrackingLoaded() => _TrackingBody(state: state),
                  };
                },
              ),
            ),
            // Always available, including while loading or on error.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      RoundIconButton(
                        icon: Icons.chevron_left,
                        tooltip: 'Back',
                        onTap: () => _goBack(context),
                      ),
                      const SizedBox(width: 10),
                      const _LiveTrackingPill(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTrackingPill extends StatelessWidget {
  const _LiveTrackingPill();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: const StadiumBorder(),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: palette.liveDot,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Live tracking',
              style: TextStyle(
                color: palette.ink,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingBody extends StatelessWidget {
  const _TrackingBody({required this.state});

  final BusTrackingLoaded state;

  static const double _sheetRadius = 28;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tracking = state.tracking;

    return LayoutBuilder(
      builder: (context, constraints) {
        final mapHeight = constraints.maxHeight * 0.4;
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: mapHeight,
              child: TrackingMapView(tracking: tracking),
            ),
            Positioned(
              top: mapHeight - _sheetRadius,
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(_sheetRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        children: [
                          BusHeader(tracking: tracking),
                          const SizedBox(height: 16),
                          ArrivalCard(tracking: tracking),
                          const SizedBox(height: 20),
                          Text(
                            'Route progress',
                            style: TextStyle(
                              color: palette.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RouteProgressList(stops: tracking.stops),
                        ],
                      ),
                    ),
                    _ActionBar(alertEnabled: state.alertEnabled),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.alertEnabled});

  final bool alertEnabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: palette.onPrimary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed:
                    () => context.read<BusTrackingBloc>().add(
                      const BusTrackingAlertToggled(),
                    ),
                icon: Icon(
                  alertEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                ),
                label: Text(
                  alertEnabled
                      ? 'Alert set · 1 stop before'
                      : 'Alert me 1 stop before',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: palette.tile,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showComingSoon(context, 'Calling the driver'),
                child: SizedBox.square(
                  dimension: 52,
                  child: Icon(Icons.call_outlined, color: palette.primaryText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
