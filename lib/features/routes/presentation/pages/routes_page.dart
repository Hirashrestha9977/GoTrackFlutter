import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Placeholder until the Routes screen is designed.
class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: const SafeArea(
        child: ComingSoonView(
          icon: Icons.route_outlined,
          title: 'Routes',
          message: 'Browse every bus route and its stops in one place.',
        ),
      ),
    );
  }
}
