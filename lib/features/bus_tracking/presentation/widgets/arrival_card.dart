import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/bus_tracking.dart';

/// "Bus 07 · Lagankhel → Budanilkantha" with the on-time pill.
class BusHeader extends StatelessWidget {
  const BusHeader({super.key, required this.tracking});

  final BusTracking tracking;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isLate = tracking.status == BusStatus.delayed;

    return Row(
      children: [
        const BusTile(size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bus ${tracking.busNumber}',
                style: TextStyle(
                  color: palette.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${tracking.origin} → ${tracking.destination}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.muted, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isLate ? palette.liveBackground : palette.primarySoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            switch (tracking.status) {
              BusStatus.onTime => 'On time',
              BusStatus.delayed => 'Delayed',
              BusStatus.early => 'Early',
            },
            style: TextStyle(
              color: isLate ? palette.liveText : palette.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Blue card with the ETA to the user's stop and a progress bar.
class ArrivalCard extends StatelessWidget {
  const ArrivalCard({super.key, required this.tracking});

  final BusTracking tracking;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final onPrimary = palette.onPrimary;
    final faded = onPrimary.withValues(alpha: 0.85);
    final userStop = tracking.userStop;
    final stopsLabel = tracking.stopsAway == 1 ? 'stop' : 'stops';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userStop == null
                          ? 'Arriving at'
                          : 'Arriving at your stop',
                      style: TextStyle(color: faded, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userStop?.name ?? tracking.destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatEta(tracking.etaMinutes),
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: tracking.progress,
              minHeight: 5,
              color: onPrimary,
              backgroundColor: onPrimary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${tracking.stopsAway} $stopsLabel away · '
            '${formatDistance(tracking.distanceMeters)} · '
            '${tracking.speedKmh} km/h',
            style: TextStyle(color: faded, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
