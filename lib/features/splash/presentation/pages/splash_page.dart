import 'package:flutter/material.dart';

/// Shown while the saved session is being checked. The router moves on
/// to login or home as soon as AuthBloc leaves its initial state.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
