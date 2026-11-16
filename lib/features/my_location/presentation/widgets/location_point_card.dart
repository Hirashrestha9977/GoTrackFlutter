import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/location_trail.dart';

/// Details of the trail point the user tapped.
class LocationPointCard extends StatelessWidget {
  const LocationPointCard({
    super.key,
    required this.point,
    required this.index,
    required this.total,
    required this.onClose,
  });

  final LocationPoint point;

  /// Zero-based position of [point] in the trail of [total] points.
  final int index;
  final int total;
  final VoidCallback onClose;

  String? get _badge {
    if (index == total - 1) return 'Latest';
    if (index == 0) return 'Start';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final recordedAt = point.recordedAt;
    final speed = point.speedKmh;
    final badge = _badge;

    return Material(
      color: palette.surface,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    point.place.isEmpty ? 'Point ${index + 1}' : point.place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primarySoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  tooltip: 'Close',
                  icon: Icon(Icons.close, color: palette.muted),
                ),
              ],
            ),
            _DetailRow(
              icon: Icons.timeline,
              label: 'Point',
              value: '${index + 1} of $total',
            ),
            if (recordedAt != null)
              _DetailRow(
                icon: Icons.schedule,
                label: 'Time',
                value: formatDateTime(recordedAt),
              ),
            if (speed != null)
              _DetailRow(
                icon: Icons.speed,
                label: 'Speed',
                value: speed == 0 ? 'Stopped' : '$speed km/h',
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(top: 6, right: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: palette.muted),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: palette.muted, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: palette.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
