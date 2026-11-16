import '../../domain/entities/user.dart';

/// Data-layer representation of [User] that knows about JSON.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userType: _userTypeFromJson(json['user_type'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'user_type': _userTypeToJson(userType),
  };

  static UserType _userTypeFromJson(String? value) {
    return switch (value) {
      'owner' => UserType.owner,
      'bus_owner' => UserType.busOwner,
      _ => UserType.generalUser,
    };
  }

  static String _userTypeToJson(UserType type) {
    return switch (type) {
      UserType.owner => 'owner',
      UserType.generalUser => 'general_user',
      UserType.busOwner => 'bus_owner',
    };
  }
}
