import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Search field and language switch floating over the map.
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    super.key,
    required this.onSearchTap,
    required this.onLanguageTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onSearchTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          child: Row(
            children: [
              Icon(Icons.search, color: palette.primaryText),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Where are you going?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: palette.muted, fontSize: 16),
                ),
              ),
              Material(
                color: palette.tile,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onLanguageTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      'EN · ने',
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontally scrolling route filter: "All routes" plus one chip per route.
class RouteChips extends StatelessWidget {
  const RouteChips({
    super.key,
    required this.routes,
    required this.selectedRouteId,
    required this.onSelected,
  });

  /// Route id -> route name, in display order.
  final Map<String, String> routes;
  final String? selectedRouteId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = <(String?, String)>[
      (null, 'All routes'),
      for (final entry in routes.entries) (entry.key, entry.value),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (id, label) = chips[index];
          return _RouteChip(
            label: label,
            selected: id == selectedRouteId,
            onTap: () => onSelected(id),
          );
        },
      ),
    );
  }
}

class _RouteChip extends StatelessWidget {
  const _RouteChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shape = StadiumBorder(
      side: selected ? BorderSide.none : BorderSide(color: palette.divider),
    );
    return Material(
      color: selected ? palette.primary : palette.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? palette.onPrimary : palette.ink,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
