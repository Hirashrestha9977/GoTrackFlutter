/// `450` -> `450 m`, `1400` -> `1.4 km`.
String formatDistance(int meters) {
  if (meters < 1000) return '$meters m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

/// `4` -> `4 min`, `0` -> `Now`.
String formatEta(int minutes) => minutes <= 0 ? 'Now' : '$minutes min';
