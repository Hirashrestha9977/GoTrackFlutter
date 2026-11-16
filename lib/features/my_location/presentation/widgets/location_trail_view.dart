import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/location_trail.dart';

/// The map layer of the My location tab: a Google map with the travelled
/// path, a tappable dot per recorded position and a pin on the most recent
/// one. The map can be dragged and pinch-zoomed, and has zoom buttons.
class LocationTrailView extends StatefulWidget {
  const LocationTrailView({
    super.key,
    required this.trail,
    required this.selectedIndex,
    required this.onPointTap,
    required this.onMapTap,
    this.padding = EdgeInsets.zero,
  });

  final LocationTrail trail;
  final int? selectedIndex;

  /// Called with the index of the tapped point.
  final ValueChanged<int> onPointTap;

  /// Called when the map is tapped away from any point.
  final VoidCallback onMapTap;

  /// Space covered by the page's overlays, so the trail, the selected point
  /// and the Google logo stay visible.
  final EdgeInsets padding;

  @override
  State<LocationTrailView> createState() => _LocationTrailViewState();
}

class _LocationTrailViewState extends State<LocationTrailView> {
  /// Shown until the trail is framed, and when the trail is empty.
  static const LatLng _kathmandu = LatLng(27.7172, 85.3240);
  static const double _singlePointZoom = 16;

  GoogleMapController? _controller;

  // Dot icons are drawn in the app's colours, so they are rebuilt when the
  // theme or the screen density changes.
  BitmapDescriptor? _dotIcon;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _selectedIcon;
  Object? _iconsKey;

  List<LatLng> get _positions => [
    for (final point in widget.trail.points)
      LatLng(point.latitude, point.longitude),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final palette = context.palette;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final key = (palette.primary, palette.surface, pixelRatio);
    if (key != _iconsKey) {
      _iconsKey = key;
      unawaited(_buildIcons(palette, pixelRatio, key));
    }
  }

  @override
  void didUpdateWidget(LocationTrailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trail != oldWidget.trail) {
      _fitTrail();
      return;
    }
    final selected = widget.selectedIndex;
    if (selected != null && selected != oldWidget.selectedIndex) {
      // Bring the tapped point into the part of the map the card leaves free.
      _controller?.animateCamera(CameraUpdate.newLatLng(_positions[selected]));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _buildIcons(
    AppPalette palette,
    double pixelRatio,
    Object key,
  ) async {
    final icons = await Future.wait([
      _dotBitmap(
        diameter: 12,
        fill: palette.surface,
        border: palette.primary,
        borderWidth: 2.5,
        pixelRatio: pixelRatio,
      ),
      _dotBitmap(
        diameter: 16,
        fill: palette.surface,
        border: palette.primary,
        borderWidth: 3.5,
        pixelRatio: pixelRatio,
      ),
      _dotBitmap(
        diameter: 22,
        fill: palette.primary,
        border: palette.surface,
        borderWidth: 3.5,
        pixelRatio: pixelRatio,
      ),
    ]);
    // Skip if the widget went away or the theme changed again meanwhile.
    if (!mounted || key != _iconsKey) return;
    setState(() {
      _dotIcon = icons[0];
      _startIcon = icons[1];
      _selectedIcon = icons[2];
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // The map needs a laid-out size before it can frame the trail.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fitTrail(animate: false);
    });
  }

  /// Moves the camera so the whole trail is visible.
  Future<void> _fitTrail({bool animate = true}) async {
    final controller = _controller;
    final positions = _positions;
    if (controller == null || positions.isEmpty) return;

    final CameraUpdate update;
    final bounds = _boundsOf(positions);
    if (bounds == null) {
      update = CameraUpdate.newLatLngZoom(positions.last, _singlePointZoom);
    } else {
      update = CameraUpdate.newLatLngBounds(bounds, 48);
    }
    await (animate
        ? controller.animateCamera(update)
        : controller.moveCamera(update));
  }

  /// `null` when every position is the same spot, which has no area to fit.
  static LatLngBounds? _boundsOf(List<LatLng> positions) {
    var south = positions.first.latitude;
    var north = south;
    var west = positions.first.longitude;
    var east = west;
    for (final position in positions) {
      if (position.latitude < south) south = position.latitude;
      if (position.latitude > north) north = position.latitude;
      if (position.longitude < west) west = position.longitude;
      if (position.longitude > east) east = position.longitude;
    }
    if (south == north && west == east) return null;
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  Set<Marker> _markers(List<LatLng> positions) {
    final dotIcon = _dotIcon;
    final startIcon = _startIcon;
    final selectedIcon = _selectedIcon;
    final lastIndex = positions.length - 1;
    final selectedIndex = widget.selectedIndex;

    return {
      // Dots appear once their icons have been drawn.
      if (dotIcon != null && startIcon != null && selectedIcon != null)
        for (var i = 0; i < lastIndex; i++)
          Marker(
            markerId: MarkerId('point-$i'),
            position: positions[i],
            anchor: const Offset(0.5, 0.5),
            icon:
                i == selectedIndex
                    ? selectedIcon
                    : (i == 0 ? startIcon : dotIcon),
            zIndexInt: i == selectedIndex ? 1 : 0,
            // Keep the camera and the app's own details card in charge.
            consumeTapEvents: true,
            onTap: () => widget.onPointTap(i),
          ),
      if (lastIndex >= 0)
        Marker(
          markerId: const MarkerId('last-location'),
          position: positions[lastIndex],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          zIndexInt: 2,
          consumeTapEvents: true,
          onTap: () => widget.onPointTap(lastIndex),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final positions = _positions;

    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: positions.isEmpty ? _kathmandu : positions.last,
              zoom: 13,
            ),
            onMapCreated: _onMapCreated,
            onTap: (_) => widget.onMapTap(),
            padding: widget.padding,
            polylines: {
              if (positions.length > 1)
                Polyline(
                  polylineId: const PolylineId('trail'),
                  points: positions,
                  color: palette.primary,
                  width: 5,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                ),
            },
            markers: _markers(positions),
            // Dragging and pinch-zoom are on by default; the app draws its
            // own zoom buttons so they look the same on iOS and Android.
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
        Positioned(
          right: 16,
          top: widget.padding.top + 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundIconButton(
                icon: Icons.add,
                tooltip: 'Zoom in',
                onTap: () => _controller?.animateCamera(CameraUpdate.zoomIn()),
              ),
              const SizedBox(height: 12),
              RoundIconButton(
                icon: Icons.remove,
                tooltip: 'Zoom out',
                onTap: () => _controller?.animateCamera(CameraUpdate.zoomOut()),
              ),
              const SizedBox(height: 12),
              RoundIconButton(
                icon: Icons.center_focus_strong_outlined,
                tooltip: 'Show whole path',
                foreground: palette.primaryText,
                onTap: _fitTrail,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Draws a bordered dot centred in a larger transparent square, so the
/// marker is easier to tap than the dot alone.
Future<BitmapDescriptor> _dotBitmap({
  required double diameter,
  required Color fill,
  required Color border,
  required double borderWidth,
  required double pixelRatio,
}) async {
  const tapTarget = 32.0;
  final pixels = (tapTarget * pixelRatio).ceil();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(pixelRatio);
  const center = Offset(tapTarget / 2, tapTarget / 2);
  final radius = diameter / 2;
  canvas
    ..drawCircle(center, radius, Paint()..color = border)
    ..drawCircle(center, radius - borderWidth, Paint()..color = fill);

  final picture = recorder.endRecording();
  final image = await picture.toImage(pixels, pixels);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  picture.dispose();
  image.dispose();

  return BitmapDescriptor.bytes(
    Uint8List.sublistView(bytes!),
    width: tapTarget,
    height: tapTarget,
  );
}
