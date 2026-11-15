import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// Pill-shaped bus badge shown on the map.
class BusMarker extends StatelessWidget {
  const BusMarker({
    super.key,
    required this.number,
    this.emphasized = true,
    this.highlighted = false,
    this.onTap,
  });

  final String number;

  /// Solid brand colour when true, pale tint when false.
  final bool emphasized;

  /// Draws a soft halo behind the badge.
  final bool highlighted;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final background = emphasized ? palette.primary : palette.primarySoft;
    final foreground = emphasized ? palette.onPrimary : palette.primaryText;

    final badge = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: palette.surface, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus_outlined, size: 15, color: foreground),
            const SizedBox(width: 5),
            Text(
              number,
              style: TextStyle(
                color: foreground,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );

    if (!highlighted) return badge;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: palette.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        badge,
      ],
    );
  }
}
