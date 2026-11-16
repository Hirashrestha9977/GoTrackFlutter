import 'package:flutter_test/flutter_test.dart';
import 'package:gotrack/core/error/exceptions.dart';
import 'package:gotrack/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:gotrack/features/auth/data/models/user_model.dart';
import 'package:gotrack/features/auth/domain/entities/user.dart';

void main() {
  const dataSource = AuthMockDataSource(delay: Duration.zero);

  test('the test owner account signs in as an owner', () async {
    final result = await dataSource.login(
      email: 'hira@gmail.com',
      password: '123456',
    );
    expect(result.user.userType, UserType.owner);
  });

  test('the owner account rejects a wrong password', () {
    expect(
      () => dataSource.login(email: 'hira@gmail.com', password: 'nope'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('any other account signs in as a general user', () async {
    final result = await dataSource.login(
      email: 'someone@mail.com',
      password: 'anything',
    );
    expect(result.user.userType, UserType.generalUser);
  });

  test('the user type survives being cached as JSON', () {
    const owner = UserModel(
      id: '1',
      name: 'Hira',
      email: 'hira@gmail.com',
      userType: UserType.owner,
    );
    expect(UserModel.fromJson(owner.toJson()), owner);
  });
}
