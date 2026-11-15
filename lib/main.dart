import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_bloc_observer.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) Bloc.observer = AppBlocObserver();

  await initDependencies();
  sl<AuthBloc>().add(const AuthCheckRequested());

  runApp(const GotrackApp());
}
