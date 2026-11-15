import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/stop_arrivals.dart';

/// White rounded card used for every row on the Stops tab.
class StopCard extends StatelessWidget {
  const StopCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// One upcoming bus with its ETA and a "Track" button.
class ArrivalTile extends StatelessWidget {
  const ArrivalTile({super.key, required this.arrival, required this.onTrack});

  final Arrival arrival;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return StopCard(
      child: Row(
        children: [
          BusTile(label: arrival.busNumber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To ${arrival.destination}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  arrival.routeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: palette.muted, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatEta(arrival.etaMinutes),
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Material(
                color: palette.tile,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onTrack,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: Text(
                      'Track',
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Arrival alerts" row with its checkbox.
class ArrivalAlertsTile extends StatelessWidget {
  const ArrivalAlertsTile({
    super.key,
    required this.leadMinutes,
    required this.enabled,
    required this.onToggle,
  });

  final int leadMinutes;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return StopCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.tile,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.notifications_none, color: palette.primaryText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arrival alerts',
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Notify me $leadMinutes min before a bus arrives',
                  style: TextStyle(color: palette.muted, fontSize: 14),
                ),
              ],
            ),
          ),
          Checkbox(
            value: enabled,
            activeColor: palette.primary,
            checkColor: palette.onPrimary,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}
