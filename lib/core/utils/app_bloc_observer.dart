import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs every bloc transition and error in debug builds.
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(
      '${bloc.runtimeType}: ${transition.currentState.runtimeType} '
      '-> ${transition.nextState.runtimeType} '
      '(${transition.event.runtimeType})',
      name: 'bloc',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log(
      '${bloc.runtimeType} error',
      name: 'bloc',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
