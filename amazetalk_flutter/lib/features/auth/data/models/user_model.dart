import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required id,
      required email,
      required name,
      required String token,
      String image = ''})
      : super(id: id, name: name, email: email, token: token);

  @override
  String toString() {
    return 'UserModel{$id, $email, $name,$token}';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] ?? '', // Ensure safe access
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json["token"] ?? '',
      image: json['image'] ?? '');
}
