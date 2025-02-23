import 'package:amazetalk_flutter/features/conversation/domain/entities/messages_entity.dart';

class MessagesModel extends MessagesEntity {
  MessagesModel(
      {required super.success,
      required super.friendName,
      required super.friendId,
      required super.messages});

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        success: json["success"],
        friendName: json["friendName"],
        friendId: json["friendId"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );
}
