import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/bus_marker.dart';
import '../../../../core/widgets/map_canvas.dart';
import '../../domain/entities/live_map.dart';

/// The map layer of the Live map tab: routes, stops, buses and the user.
class LiveMapView extends StatelessWidget {
  const LiveMapView({
    super.key,
    required this.map,
    required this.selectedRouteId,
    required this.onBusTap,
  });

  final LiveMap map;
  final String? selectedRouteId;
  final ValueChanged<NearbyBus> onBusTap;

  bool _isSelected(String routeId) {
    return selectedRouteId == null || routeId == selectedRouteId;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    // Unselected routes first so the selected one is painted on top.
    final routes = [...map.routes]..sort(
      (a, b) => (_isSelected(a.id) ? 1 : 0) - (_isSelected(b.id) ? 1 : 0),
    );

    // The closest bus on the selected route gets the halo.
    NearbyBus? nearest;
    for (final bus in map.buses) {
      if (!_isSelected(bus.routeId)) continue;
      if (nearest == null || bus.etaMinutes < nearest.etaMinutes) nearest = bus;
    }

    return MapCanvas(
      lines: [
        for (final route in routes)
          _isSelected(route.id)
              ? MapLine(points: route.path, color: palette.primary)
              : MapLine(
                points: route.path,
                color: palette.primary.withValues(alpha: 0.45),
                width: 5,
                dashed: true,
              ),
      ],
      dots: [
        for (final route in routes)
          if (_isSelected(route.id))
            for (final stop in route.stops)
              MapDot(
                point: stop,
                fill: palette.surface,
                border: palette.primary,
              ),
      ],
      markers: [
        MapMarker(point: map.userLocation, child: const _UserLocation()),
        for (final bus in map.buses)
          MapMarker(
            point: bus.position,
            child: BusMarker(
              number: bus.number,
              emphasized: _isSelected(bus.routeId),
              highlighted: bus == nearest,
              onTap: () => onBusTap(bus),
            ),
          ),
      ],
    );
  }
}

class _UserLocation extends StatelessWidget {
  const _UserLocation();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: palette.primary,
          shape: BoxShape.circle,
          border: Border.all(color: palette.surface, width: 3),
        ),
      ),
    );
  }
}
