import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';

/// Signed-in shell: hosts the four tabs and the bottom navigation bar.
/// Each tab keeps its own state while the user switches between them.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Order must match the branches declared in `AppRouter`.
  static const List<(String, IconData)> _tabs = [
    ('Live map', Icons.map_outlined),
    ('Routes', Icons.route_outlined),
    ('Stops', Icons.location_on_outlined),
    ('Profile', Icons.person_outline),
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
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _TabItem(
                      label: _tabs[i].$1,
                      icon: _tabs[i].$2,
                      selected: i == navigationShell.currentIndex,
                      onTap: () => _onTap(i),
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
