import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Placeholder until the Profile screen is designed. Logging out lives
/// here so it stays reachable now that the old home page is gone.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is Authenticated ? state.user : null;
            return ComingSoonView(
              icon: Icons.person_outline,
              title: 'Profile',
              message: 'Saved stops, alerts and account settings.',
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user != null) ...[
                    Text(
                      'Signed in as ${user.name.isEmpty ? user.email : user.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: palette.muted, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                  ],
                  OutlinedButton.icon(
                    onPressed:
                        () => context.read<AuthBloc>().add(
                          const AuthLogoutRequested(),
                        ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
