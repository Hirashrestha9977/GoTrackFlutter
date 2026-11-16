import 'package:equatable/equatable.dart';

enum UserType { owner, generalUser, busOwner }

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.userType = UserType.generalUser,
  });

  final String id;
  final String name;
  final String email;
  final UserType userType;

  @override
  List<Object?> get props => [id, name, email, userType];
}
