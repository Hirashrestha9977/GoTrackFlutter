import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF1D4ED8);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final palette =
        brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      extensions: [palette],
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
    );
  }
}
