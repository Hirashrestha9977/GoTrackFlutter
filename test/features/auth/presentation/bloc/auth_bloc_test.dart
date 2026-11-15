import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrack/core/error/failures.dart';
import 'package:gotrack/core/usecase/usecase.dart';
import 'package:gotrack/features/auth/domain/entities/user.dart';
import 'package:gotrack/features/auth/domain/usecases/get_cached_user.dart';
import 'package:gotrack/features/auth/domain/usecases/login.dart';
import 'package:gotrack/features/auth/domain/usecases/logout.dart';
import 'package:gotrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

class MockLogout extends Mock implements Logout {}

class MockGetCachedUser extends Mock implements GetCachedUser {}

void main() {
  late MockLogin login;
  late MockLogout logout;
  late MockGetCachedUser getCachedUser;

  const user = User(id: '1', name: 'Test', email: 'test@example.com');
  const params = LoginParams(email: 'test@example.com', password: 'secret');

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(params);
  });

  setUp(() {
    login = MockLogin();
    logout = MockLogout();
    getCachedUser = MockGetCachedUser();
  });

  AuthBloc build() =>
      AuthBloc(login: login, logout: logout, getCachedUser: getCachedUser);

  test('starts in AuthInitial', () {
    expect(build().state, const AuthInitial());
  });

  blocTest<AuthBloc, AuthState>(
    'check: emits Authenticated when a session is cached',
    setUp:
        () => when(
          () => getCachedUser(any()),
        ).thenAnswer((_) async => const Right(user)),
    build: build,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => [const Authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'check: emits Unauthenticated when nothing is cached',
    setUp:
        () => when(
          () => getCachedUser(any()),
        ).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => [const Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'login: emits Loading then Authenticated on success',
    setUp:
        () => when(
          () => login(params),
        ).thenAnswer((_) async => const Right(user)),
    build: build,
    act:
        (bloc) => bloc.add(
          AuthLoginRequested(email: params.email, password: params.password),
        ),
    expect: () => [const AuthLoading(), const Authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'login: emits Loading then AuthError on failure',
    setUp:
        () => when(() => login(params)).thenAnswer(
          (_) async => const Left(UnauthorizedFailure('Invalid credentials')),
        ),
    build: build,
    act:
        (bloc) => bloc.add(
          AuthLoginRequested(email: params.email, password: params.password),
        ),
    expect: () => [const AuthLoading(), const AuthError('Invalid credentials')],
  );

  blocTest<AuthBloc, AuthState>(
    'logout: emits Unauthenticated',
    setUp:
        () => when(
          () => logout(any()),
        ).thenAnswer((_) async => const Right(null)),
    build: build,
    seed: () => const Authenticated(user),
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    expect: () => [const Unauthenticated()],
    verify: (_) => verify(() => logout(any())).called(1),
  );
}
