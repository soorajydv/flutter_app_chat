import 'package:amazetalk_flutter/features/conversation/domain/entities/group_info.dart';

class GroupInfo extends GroupInfoEntity {
  GroupInfo({required super.adminId, required super.userMappings});
  factory GroupInfo.fromJson(Map<String, dynamic> json) => GroupInfo(
        adminId: json["adminId"],
        userMappings: List<UserMapping>.from(json["userMappings"]
            .map((x) => UserMapping.fromJson(x, json['adminId']))),
      );
}
