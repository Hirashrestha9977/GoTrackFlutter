import 'dart:convert';

import 'package:flutter/services.dart';

import '../error/exceptions.dart';

/// Reads a bundled JSON file and returns it the way `ApiClient` returns a
/// decoded response body, so mock data sources look like remote ones.
///
/// Throws [ServerException] if the file is missing or is not a JSON object.
class MockJsonLoader {
  const MockJsonLoader({
    AssetBundle? bundle,
    this.delay = const Duration(milliseconds: 400),
  }) : _bundle = bundle;

  final AssetBundle? _bundle;

  /// Simulated network latency so loading states are visible.
  final Duration delay;

  Future<Map<String, dynamic>> load(String assetPath) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    try {
      final raw = await (_bundle ?? rootBundle).loadString(assetPath);
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      throw ServerException('Could not load mock data: $assetPath');
    }
  }
}
