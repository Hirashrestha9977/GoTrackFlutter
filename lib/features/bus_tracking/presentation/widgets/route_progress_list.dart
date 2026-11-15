import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/bus_tracking.dart';
import 'tracking_map_view.dart';

/// Stops in travel order, with a "Bus is here" row after the last stop
/// the bus has passed.
class RouteProgressList extends StatelessWidget {
  const RouteProgressList({super.key, required this.stops});

  final List<RouteStop> stops;

  @override
  Widget build(BuildContext context) {
    final busIndex = stops.lastIndexWhere((stop) => stop.isPassed) + 1;

    return Column(
      children: [
        for (var i = 0; i < stops.length; i++) ...[
          if (i == busIndex) const _BusHereRow(),
          _StopRow(stop: stops[i]),
        ],
        if (busIndex == stops.length) const _BusHereRow(),
      ],
    );
  }
}

class _BusHereRow extends StatelessWidget {
  const _BusHereRow();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return _Row(
      indicator: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: palette.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          Icons.directions_bus_outlined,
          size: 15,
          color: palette.onPrimary,
        ),
      ),
      title: Text(
        'Bus is here',
        style: TextStyle(
          color: palette.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Text('Now', style: TextStyle(color: palette.muted)),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({required this.stop});

  final RouteStop stop;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final eta = stop.etaMinutes;

    final Widget indicator;
    if (stop.isPassed) {
      indicator = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: palette.passed,
          shape: BoxShape.circle,
        ),
      );
    } else if (stop.isUserStop) {
      indicator = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: palette.primary,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.primarySoft, width: 2.5),
        ),
      );
    } else {
      indicator = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.primary, width: 2.5),
        ),
      );
    }

    return _Row(
      highlighted: stop.isUserStop,
      indicator: indicator,
      title: Row(
        children: [
          Flexible(
            child: Text(
              stop.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: stop.isPassed ? palette.muted : palette.ink,
                fontSize: 16,
                fontWeight: stop.isUserStop ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          if (stop.isUserStop) ...[
            const SizedBox(width: 8),
            const YourStopBadge(),
          ],
        ],
      ),
      trailing: Text(
        stop.isPassed || eta == null ? 'Passed' : formatEta(eta),
        style:
            stop.isUserStop
                ? TextStyle(
                  color: palette.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                )
                : TextStyle(color: palette.muted, fontSize: 14),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.indicator,
    required this.title,
    required this.trailing,
    this.highlighted = false,
  });

  final Widget indicator;
  final Widget title;
  final Widget trailing;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: highlighted ? context.palette.tile : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Center(child: indicator)),
          const SizedBox(width: 12),
          Expanded(child: title),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}
