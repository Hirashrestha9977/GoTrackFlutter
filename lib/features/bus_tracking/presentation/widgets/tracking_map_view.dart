import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/bus_marker.dart';
import '../../../../core/widgets/map_canvas.dart';
import '../../domain/entities/bus_tracking.dart';

/// Map for a single bus: grey where it has been, blue where it is going.
class TrackingMapView extends StatelessWidget {
  const TrackingMapView({super.key, required this.tracking});

  final BusTracking tracking;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final userStop = tracking.userStop;

    return MapCanvas(
      lines: [
        MapLine(points: tracking.passedPath, color: palette.passed),
        MapLine(points: tracking.upcomingPath, color: palette.primary),
      ],
      dots: [
        for (final stop in tracking.stops)
          if (stop.isUserStop)
            MapDot(
              point: stop.position,
              fill: palette.primary,
              border: palette.surface,
              radius: 9,
            )
          else
            MapDot(
              point: stop.position,
              fill: palette.surface,
              border: stop.isPassed ? palette.passed : palette.primary,
            ),
      ],
      markers: [
        if (userStop != null)
          MapMarker(
            point: userStop.position,
            // Starts to the right of the stop dot, vertically centred on it.
            anchor: const Offset(0, -0.5),
            child: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: YourStopBadge(),
            ),
          ),
        MapMarker(
          point: tracking.busPosition,
          child: BusMarker(number: tracking.busNumber, highlighted: true),
        ),
      ],
    );
  }
}

/// Dark "Your stop" label, used on the map and in the stop list.
class YourStopBadge extends StatelessWidget {
  const YourStopBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: palette.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Your stop',
        style: TextStyle(
          color: palette.surface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
