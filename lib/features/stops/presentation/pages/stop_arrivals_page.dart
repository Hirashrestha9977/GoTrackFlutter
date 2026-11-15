import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/stop_arrivals.dart';
import '../bloc/stop_arrivals_bloc.dart';
import '../widgets/arrival_tile.dart';
import '../widgets/stop_header.dart';

class StopArrivalsPage extends StatelessWidget {
  const StopArrivalsPage({super.key, required this.stopId});

  final String stopId;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.liveMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.palette.background,
        body: BlocBuilder<StopArrivalsBloc, StopArrivalsState>(
          builder: (context, state) {
            final bloc = context.read<StopArrivalsBloc>();
            final loaded = state is StopArrivalsLoaded ? state : null;

            return Column(
              children: [
                StopHeader(
                  stop: loaded?.stop,
                  isSaved: loaded?.isSaved ?? false,
                  onBack: () => _goBack(context),
                  onSaveToggle:
                      loaded == null
                          ? null
                          : () => bloc.add(const StopArrivalsSaveToggled()),
                ),
                Expanded(
                  child: switch (state) {
                    StopArrivalsInitial() || StopArrivalsLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    StopArrivalsError(:final message) => ErrorView(
                      message: message,
                      onRetry: () => bloc.add(StopArrivalsStarted(stopId)),
                    ),
                    StopArrivalsLoaded() => _ArrivalsList(state: state),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArrivalsList extends StatelessWidget {
  const _ArrivalsList({required this.state});

  final StopArrivalsLoaded state;

  void _track(BuildContext context, Arrival arrival) {
    context.pushNamed(
      RouteNames.busTracking,
      pathParameters: {'busId': arrival.busId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final stop = state.stop;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Next arrivals',
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const LiveBadge(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (stop.arrivals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Text(
              'No buses are due at this stop right now',
              style: TextStyle(color: palette.muted, fontSize: 15),
            ),
          ),
        for (final arrival in stop.arrivals) ...[
          ArrivalTile(
            arrival: arrival,
            onTrack: () => _track(context, arrival),
          ),
          const SizedBox(height: 12),
        ],
        ArrivalAlertsTile(
          leadMinutes: stop.alertLeadMinutes,
          enabled: state.alertsEnabled,
          onToggle:
              () => context.read<StopArrivalsBloc>().add(
                const StopArrivalsAlertsToggled(),
              ),
        ),
      ],
    );
  }
}
