import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required id, required email, required username, required String token})
      : super(id: id, username: username, email: email, token: token);

  @override
  String toString() {
    return 'UserModel{$id, $email, $username,$token}';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {}; // Ensure 'user' exists
    final tokenData = json["token"];

    UserModel user1 = UserModel(
        id: user['_id'] ?? '', // Ensure safe access
        username: user['username'] ?? '',
        email: user['email'] ?? '',
        token: tokenData ?? '');

    return user1;
  }
}
