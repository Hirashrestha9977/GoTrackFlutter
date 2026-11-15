import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/live_map.dart';

/// Bottom panel listing the buses closest to the user.
class NearbyBusesSheet extends StatelessWidget {
  const NearbyBusesSheet({
    super.key,
    required this.buses,
    required this.updatedSecondsAgo,
    required this.isEmphasized,
    required this.onBusTap,
  });

  final List<NearbyBus> buses;
  final int updatedSecondsAgo;

  /// Whether a bus is on the currently selected route.
  final bool Function(NearbyBus bus) isEmphasized;
  final ValueChanged<NearbyBus> onBusTap;

  static const double cornerRadius = 28;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.34;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(cornerRadius),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: palette.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Nearby buses',
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                LiveBadge(label: 'Live · ${updatedSecondsAgo}s ago'),
              ],
            ),
          ),
          if (buses.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'No buses nearby right now',
                style: TextStyle(color: palette.muted, fontSize: 15),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxListHeight),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: buses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  return _NearbyBusTile(
                    bus: bus,
                    emphasized: isEmphasized(bus),
                    onTap: () => onBusTap(bus),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NearbyBusTile extends StatelessWidget {
  const _NearbyBusTile({
    required this.bus,
    required this.emphasized,
    required this.onTap,
  });

  final NearbyBus bus;
  final bool emphasized;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.tile,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              BusTile(emphasized: emphasized, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To ${bus.destination}',
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
                      'Bus ${bus.number} · ${bus.description}',
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
                    formatEta(bus.etaMinutes),
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatDistance(bus.distanceMeters),
                    style: TextStyle(color: palette.muted, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
