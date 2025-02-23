// import 'dart:convert';

import 'package:amazetalk_flutter/features/conversation/domain/entities/chats_entity.dart';

class ChatsModel extends ChatsEntity {
  ChatsModel(
      {required super.id,
      required super.chatName,
      required super.isGroupChat,
      required super.users,
      required super.latestMessage,
      required super.groupAdmin});

  factory ChatsModel.fromJson(Map<String, dynamic> json) {
    return ChatsModel(
      id: json['_id'] ?? '', // Default to empty string if null
      chatName: json['chatName'] ?? '', // Default to empty string if null
      isGroupChat: json['isGroupChat'] ?? false, // Default to false if null
      users: json['users'] != null
          ? (json['users'] as List)
              .map((user) => GroupAdmin.fromJson(user))
              .toList()
          : [], // Default to empty list if null
      latestMessage: json['latestMessage'] != null
          ? LatestMessage.fromJson(json['latestMessage'])
          : LatestMessage(
              id: '',
              sender: Sender(id: '', name: '', email: ''),
              content: '',
              chat: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()), // Default to empty message if null
      groupAdmin: json['groupAdmin'] != null
          ? GroupAdmin.fromJson(json['groupAdmin'])
          : null, // Null if not present
    );
  }

  static List<ChatsModel> fromResponse(List<dynamic> data) =>
      data.map((chat) => ChatsModel.fromJson(chat)).toList();

  // factory ChatsModel.fromJson(Map<String, dynamic> json) {
  //   return ChatsModel(
  //     id: json['_id'],
  //     chatName: json['chatName'] ?? 'No Name',
  //     isGroupChat: json['isGroupChat'] ?? false,
  //     users: List<User>.from(json['users'].map((user) => User.fromJson(user))),
  //     groupAdmin:
  //         json['groupAdmin'] != null ? User.fromJson(json['groupAdmin']) : null,
  //     latestMessage: Message.fromJson(json['latestMessage']),
  //     // v: json['__v'],
  //   );
  // }

// Function to parse JSON string into a List<Chat>
  // static List<ChatsModel> parseResponse(String jsonString) {
  //   final jsonData = json.decode(jsonString);
  //   print('Json data: $jsonData');
  //   final result = jsonData.map((chat) => ChatsModel.fromJson(chat)).toList();

  //   for (var element in result) {
  //     print('Chat: ${element.runtimeType}');
  //   }
  //   return result;
  // }
}
