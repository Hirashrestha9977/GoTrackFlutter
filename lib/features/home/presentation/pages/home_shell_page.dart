import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Signed-in shell: hosts the tabs and the bottom navigation bar. Which
/// tabs are shown depends on the signed-in user's type.
/// Each tab keeps its own state while the user switches between them.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // The first value is the index of the branch declared in `AppRouter`.
  static const List<(int, String, IconData)> _generalTabs = [
    (0, 'Live map', Icons.map_outlined),
    (1, 'Routes', Icons.route_outlined),
    (2, 'Stops', Icons.location_on_outlined),
    (3, 'Profile', Icons.person_outline),
  ];
  static const List<(int, String, IconData)> _ownerTabs = [
    (4, 'My location', Icons.my_location),
    (3, 'Profile', Icons.person_outline),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Tapping the active tab returns it to its first page.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isOwner = context.select<AuthBloc, bool>((bloc) {
      final state = bloc.state;
      return state is Authenticated && state.user.userType == UserType.owner;
    });
    final tabs = isOwner ? _ownerTabs : _generalTabs;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border(top: BorderSide(color: palette.divider)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (final (branch, label, icon) in tabs)
                  Expanded(
                    child: _TabItem(
                      label: label,
                      icon: icon,
                      selected: branch == navigationShell.currentIndex,
                      onTap: () => _onTap(branch),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = selected ? palette.primaryText : palette.muted;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
