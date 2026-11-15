/// Static JSON files that stand in for API responses until the backend
/// is ready. Each file mirrors the shape the matching endpoint should return.
class MockAssets {
  MockAssets._();

  static const String liveMap = 'assets/mock/live_map.json';
  static const String busTracking = 'assets/mock/bus_tracking.json';
  static const String stopArrivals = 'assets/mock/stop_arrivals.json';
}
