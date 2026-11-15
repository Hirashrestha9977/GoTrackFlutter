import 'package:flutter/material.dart';

/// Design colours that Material's [ColorScheme] has no slot for.
/// Read them with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryText,
    required this.primarySoft,
    required this.ink,
    required this.muted,
    required this.background,
    required this.surface,
    required this.tile,
    required this.divider,
    required this.passed,
    required this.mapBackground,
    required this.mapRoad,
    required this.mapPark,
    required this.liveBackground,
    required this.liveText,
    required this.liveDot,
  });

  /// Filled brand surfaces (buttons, selected chips, bus badges).
  final Color primary;
  final Color onPrimary;

  /// Brand-coloured text and icons on [surface] / [tile].
  final Color primaryText;

  /// Pale brand tint for pills and muted icon tiles.
  final Color primarySoft;

  /// Headings and primary text.
  final Color ink;

  /// Secondary text.
  final Color muted;

  final Color background;
  final Color surface;

  /// Tinted list rows.
  final Color tile;
  final Color divider;

  /// Stops and route segments the bus has already passed.
  final Color passed;

  final Color mapBackground;
  final Color mapRoad;
  final Color mapPark;

  final Color liveBackground;
  final Color liveText;
  final Color liveDot;

  static const AppPalette light = AppPalette(
    primary: Color(0xFF1D4ED8),
    onPrimary: Colors.white,
    primaryText: Color(0xFF1D4ED8),
    primarySoft: Color(0xFFDCE6FD),
    ink: Color(0xFF0B1F4D),
    muted: Color(0xFF5A6478),
    background: Color(0xFFF1F5FF),
    surface: Colors.white,
    tile: Color(0xFFEFF4FF),
    divider: Color(0xFFE2E8F0),
    passed: Color(0xFF94A3B8),
    mapBackground: Color(0xFFE4EAF6),
    mapRoad: Colors.white,
    mapPark: Color(0xFFD6E6DE),
    liveBackground: Color(0xFFFDE8DC),
    liveText: Color(0xFFB4380F),
    liveDot: Color(0xFFEA580C),
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xFF2B5CE6),
    onPrimary: Colors.white,
    primaryText: Color(0xFF8FB0FF),
    primarySoft: Color(0xFF1E2E57),
    ink: Color(0xFFE8EDFB),
    muted: Color(0xFF9AA6BF),
    background: Color(0xFF0B1220),
    surface: Color(0xFF111A2E),
    tile: Color(0xFF18233D),
    divider: Color(0xFF24304D),
    passed: Color(0xFF5E6B85),
    mapBackground: Color(0xFF0E1627),
    mapRoad: Color(0xFF1C2740),
    mapPark: Color(0xFF14302A),
    liveBackground: Color(0xFF3A1D10),
    liveText: Color(0xFFFFB38F),
    liveDot: Color(0xFFF97316),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    return other is AppPalette && t >= 0.5 ? other : this;
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
