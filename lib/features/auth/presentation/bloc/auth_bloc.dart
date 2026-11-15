import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_cached_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required Login login,
    required Logout logout,
    required GetCachedUser getCachedUser,
  }) : _login = login,
       _logout = logout,
       _getCachedUser = getCachedUser,
       super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final Login _login;
  final Logout _logout;
  final GetCachedUser _getCachedUser;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCachedUser(const NoParams());
    emit(
      result.fold(
        (_) => const Unauthenticated(),
        (user) => user == null ? const Unauthenticated() : Authenticated(user),
      ),
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    emit(
      result.fold((failure) => AuthError(failure.message), Authenticated.new),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const Unauthenticated());
  }
}
