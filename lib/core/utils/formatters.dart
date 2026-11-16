/// `450` -> `450 m`, `1400` -> `1.4 km`.
String formatDistance(int meters) {
  if (meters < 1000) return '$meters m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

/// `4` -> `4 min`, `0` -> `Now`.
String formatEta(int minutes) => minutes <= 0 ? 'Now' : '$minutes min';

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// `2026-11-16 09:02` -> `16 Nov, 9:02 AM`.
String formatDateTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour < 12 ? 'AM' : 'PM';
  return '${time.day} ${_months[time.month - 1]}, $hour:$minute $period';
}
