// To parse this JSON data, do
//
//     final messages = messagesFromJson(jsonString);

import 'dart:convert';

MessagesEntity messagesFromJson(String str) =>
    MessagesEntity.fromJson(json.decode(str));

String messagesToJson(MessagesEntity data) => json.encode(data.toJson());
String sendMessageToJson(SendMessageEntity data) => json.encode(data.toJson());

class MessagesEntity {
  final bool success;
  final String friendName;
  final String friendId;
  final List<Message> messages;

  MessagesEntity({
    required this.success,
    required this.friendName,
    required this.friendId,
    required this.messages,
  });

  factory MessagesEntity.fromJson(Map<String, dynamic> json) => MessagesEntity(
        success: json["success"],
        friendName: json["friendName"],
        friendId: json["friendId"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "friendName": friendName,
        "friendId": friendId,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  final String message;
  final bool isSent;
  final bool isReceived;

  Message({
    required this.message,
    required this.isSent,
    required this.isReceived,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"],
        isSent: json["isSent"],
        isReceived: json["isReceived"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "isSent": isSent,
        "isReceived": isReceived,
      };
}

class SendMessageEntity {
  final String receiverId;
  final String text;
  SendMessageEntity({
    required this.receiverId,
    required this.text,
  });
  Map<String, dynamic> toJson() => {
        "receiverId": receiverId,
        "text": text,
      };
}
