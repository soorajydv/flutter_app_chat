import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.image,
      required super.avatar,
      required super.token});

  @override
  String toString() {
    return 'UserModel{$id, $email, $name,$token   , $avatar}';
  }

  static Future<UserModel> fromJson(Map<String, dynamic> json) async {
    print('Login data: ${json}');
    // final filePath = json['image'];
    // final imagePath =
    //     filePath == null ? null : await ImageSaver.saveImageToGallery(filePath);

    // print('saved path: $imagePath');
    return UserModel(
        id: json['_id'] ?? '', // Ensure safe access
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        token: json["token"] ?? '',
        avatar: json["avatar"] ?? '',
        image: '');
    // );
  }
}
