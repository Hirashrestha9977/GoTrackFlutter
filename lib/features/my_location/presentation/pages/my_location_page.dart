import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/location_trail.dart';
import '../bloc/my_location_bloc.dart';
import '../widgets/location_point_card.dart';
import '../widgets/location_trail_view.dart';

/// Owner-only tab: the recorded location trail with a pin on the latest
/// position. Tapping a point opens its details.
class MyLocationPage extends StatelessWidget {
  const MyLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.palette.mapBackground,
        body: BlocBuilder<MyLocationBloc, MyLocationState>(
          builder: (context, state) {
            return switch (state) {
              MyLocationInitial() || MyLocationLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              MyLocationError(:final message) => ErrorView(
                message: message,
                onRetry: () => _reload(context),
              ),
              MyLocationLoaded() => _MyLocationBody(state: state),
            };
          },
        ),
      ),
    );
  }
}

void _reload(BuildContext context) {
  context.read<MyLocationBloc>().add(const MyLocationStarted());
}

class _MyLocationBody extends StatelessWidget {
  const _MyLocationBody({required this.state});

  final MyLocationLoaded state;

  LocationTrail get trail => state.trail;

  void _select(BuildContext context, int? index) {
    context.read<MyLocationBloc>().add(MyLocationPointSelected(index));
  }

  // Roughly what the header and the details card cover, so the map keeps
  // its content clear of them.
  static const double _headerSpace = 84;
  static const double _cardSpace = 190;

  String get _subtitle {
    final count = trail.points.length;
    if (count == 0) return 'No location recorded yet';
    final points = count == 1 ? '1 point' : '$count points';
    return 'Updated ${trail.updatedSecondsAgo} sec ago · $points · Tap one';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final selectedIndex = state.selectedIndex;

    return Stack(
      children: [
        Positioned.fill(
          child: LocationTrailView(
            trail: trail,
            selectedIndex: selectedIndex,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + _headerSpace,
              bottom: selectedIndex == null ? 0 : _cardSpace,
            ),
            // Tapping the open point again closes it.
            onPointTap:
                (index) =>
                    _select(context, index == selectedIndex ? null : index),
            // Tapping the empty map closes the details.
            onMapTap: () => _select(context, null),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Material(
                  color: palette.surface,
                  elevation: 3,
                  shadowColor: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: palette.liveDot),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My location',
                                style: TextStyle(
                                  color: palette.ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _subtitle,
                                style: TextStyle(
                                  color: palette.muted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundIconButton(
                    icon: Icons.refresh,
                    tooltip: 'Refresh',
                    foreground: palette.primaryText,
                    onTap: () => _reload(context),
                  ),
                ),
                if (selectedIndex != null) ...[
                  const SizedBox(height: 12),
                  LocationPointCard(
                    point: trail.points[selectedIndex],
                    index: selectedIndex,
                    total: trail.points.length,
                    onClose: () => _select(context, null),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
