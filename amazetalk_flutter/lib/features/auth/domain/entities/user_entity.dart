import 'package:flutter/foundation.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String image;
  final String avatar;
  final String token;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.avatar,
    required this.token,
  });

  Uint8List? get imageAvatar {
    if (image.isEmpty) return null;

    // Convert the image string (comma-separated integers) to a Uint8List

    final imageData =
        image.split(',').map((item) => int.parse(item.trim())).toList();
    return Uint8List.fromList(imageData);
  }
}
