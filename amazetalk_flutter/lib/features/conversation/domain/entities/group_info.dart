import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';

abstract class GroupInfoEntity {
  final String adminId;
  final List<UserMapping> userMappings;

  GroupInfoEntity({
    required this.adminId,
    required this.userMappings,
  });

  Future<bool> get isMeAdmin async {
    final uid = await AuthLocalDataSource().getUserId();
    return uid == adminId;
  }
}

class UserMapping {
  final String userId;
  final String username;
  final dynamic userImage;
  final bool isAdmin;

  UserMapping({
    required this.isAdmin,
    required this.userId,
    required this.username,
    required this.userImage,
  });

  factory UserMapping.fromJson(Map<String, dynamic> json, String adminId) {
    return UserMapping(
      isAdmin: json["userId"] == adminId,
      userId: json["userId"],
      username: json["username"],
      userImage: json["userImage"],
    );
  }

  String getDisplayName(String myUserId) {
    return username[0].toUpperCase() +
        username.substring(1) +
        (userId == myUserId ? ' (Me)' : '');
  }
}
