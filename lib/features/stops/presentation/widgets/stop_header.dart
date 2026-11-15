import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/stop_arrivals.dart';

/// Blue header with the stop name, distance and the back / bookmark buttons.
class StopHeader extends StatelessWidget {
  const StopHeader({
    super.key,
    required this.stop,
    required this.isSaved,
    required this.onBack,
    required this.onSaveToggle,
  });

  /// `null` while the stop is still loading.
  final StopArrivals? stop;
  final bool isSaved;
  final VoidCallback onBack;
  final VoidCallback? onSaveToggle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final onPrimary = palette.onPrimary;
    final faded = onPrimary.withValues(alpha: 0.85);
    final buttonColor = onPrimary.withValues(alpha: 0.16);
    final stop = this.stop;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundIconButton(
                    icon: Icons.chevron_left,
                    tooltip: 'Back',
                    background: buttonColor,
                    foreground: onPrimary,
                    elevation: 0,
                    onTap: onBack,
                  ),
                  if (onSaveToggle != null)
                    RoundIconButton(
                      icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                      tooltip: isSaved ? 'Remove from saved' : 'Save stop',
                      background: buttonColor,
                      foreground: onPrimary,
                      elevation: 0,
                      onTap: onSaveToggle!,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Bus stop', style: TextStyle(color: faded, fontSize: 14)),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  text: stop?.name ?? ' ',
                  children: [
                    if (stop != null && stop.localName.isNotEmpty)
                      TextSpan(
                        text: '  ${stop.localName}',
                        style: TextStyle(
                          color: faded,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 32,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: onPrimary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      stop == null
                          ? ' '
                          : '${formatDistance(stop.distanceMeters)} away · '
                              '${stop.walkMinutes} min walk',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: onPrimary, fontSize: 15),
                    ),
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
