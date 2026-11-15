import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../map/map_point.dart';
import '../theme/app_palette.dart';

/// A route line drawn on [MapCanvas].
class MapLine extends Equatable {
  const MapLine({
    required this.points,
    required this.color,
    this.width = 6,
    this.dashed = false,
  });

  final List<MapPoint> points;
  final Color color;
  final double width;
  final bool dashed;

  @override
  List<Object?> get props => [points, color, width, dashed];
}

/// A stop dot drawn on [MapCanvas].
class MapDot extends Equatable {
  const MapDot({
    required this.point,
    required this.fill,
    required this.border,
    this.radius = 6,
    this.borderWidth = 3,
  });

  final MapPoint point;
  final Color fill;
  final Color border;
  final double radius;
  final double borderWidth;

  @override
  List<Object?> get props => [point, fill, border, radius, borderWidth];
}

/// A widget pinned to a map position (bus badge, label, user location).
class MapMarker {
  const MapMarker({
    required this.point,
    required this.child,
    this.anchor = const Offset(-0.5, -0.5),
  });

  final MapPoint point;
  final Widget child;

  /// Fractional shift of [child] relative to [point].
  /// The default centres the child on the point.
  final Offset anchor;
}

/// Placeholder map: a drawn street grid with route lines, stops and markers
/// on top. Swap this widget for a real map SDK (Google Maps, Mapbox, ...)
/// once live coordinates are available; the pages only depend on
/// [MapLine], [MapDot] and [MapMarker].
class MapCanvas extends StatelessWidget {
  const MapCanvas({
    super.key,
    this.lines = const [],
    this.dots = const [],
    this.markers = const [],
  });

  final List<MapLine> lines;
  final List<MapDot> dots;
  final List<MapMarker> markers;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapPainter(
                    background: palette.mapBackground,
                    road: palette.mapRoad,
                    park: palette.mapPark,
                    lines: lines,
                    dots: dots,
                  ),
                ),
              ),
              for (final marker in markers)
                Positioned(
                  left: marker.point.x * size.width,
                  top: marker.point.y * size.height,
                  child: FractionalTranslation(
                    translation: marker.anchor,
                    child: marker.child,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.background,
    required this.road,
    required this.park,
    required this.lines,
    required this.dots,
  });

  final Color background;
  final Color road;
  final Color park;
  final List<MapLine> lines;
  final List<MapDot> dots;

  // Decorative street grid, in the same 0..1 space as [MapPoint].
  static const List<Rect> _parks = [
    Rect.fromLTWH(0.05, 0.38, 0.23, 0.17),
    Rect.fromLTWH(0.64, 0.63, 0.28, 0.15),
  ];
  static const List<(Offset, Offset, double)> _roads = [
    (Offset(0.30, 0), Offset(0.38, 1), 10),
    (Offset(0.69, 0), Offset(0.66, 1), 8),
    (Offset(0, 0.49), Offset(1, 0.42), 10),
    (Offset(0, 0.84), Offset(1, 0.80), 8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(double x, double y) => Offset(x * size.width, y * size.height);

    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    final parkPaint = Paint()..color = park;
    for (final rect in _parks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            rect.left * size.width,
            rect.top * size.height,
            rect.right * size.width,
            rect.bottom * size.height,
          ),
          const Radius.circular(12),
        ),
        parkPaint,
      );
    }

    for (final (from, to, width) in _roads) {
      canvas.drawLine(
        at(from.dx, from.dy),
        at(to.dx, to.dy),
        Paint()
          ..color = road
          ..strokeWidth = width,
      );
    }

    for (final line in lines) {
      if (line.points.length < 2) continue;
      final first = line.points.first;
      final path = Path()..moveTo(first.x * size.width, first.y * size.height);
      for (final point in line.points.skip(1)) {
        path.lineTo(point.x * size.width, point.y * size.height);
      }
      canvas.drawPath(
        line.dashed ? _dash(path) : path,
        Paint()
          ..color = line.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = line.width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    for (final dot in dots) {
      final center = at(dot.point.x, dot.point.y);
      canvas.drawCircle(center, dot.radius, Paint()..color = dot.fill);
      canvas.drawCircle(
        center,
        dot.radius,
        Paint()
          ..color = dot.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = dot.borderWidth,
      );
    }
  }

  Path _dash(Path source, {double dash = 14, double gap = 10}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
        dashed.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dash + gap;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) {
    return background != oldDelegate.background ||
        road != oldDelegate.road ||
        park != oldDelegate.park ||
        !listEquals(lines, oldDelegate.lines) ||
        !listEquals(dots, oldDelegate.dots);
  }
}
