import 'package:amazetalk_flutter/features/conversation/data/models/chats_model.dart';
import 'package:amazetalk_flutter/features/conversation/data/models/group_info.dart';

import '../../../../services/dio_client.dart';
import '../models/message_model.dart';

class ChatsRemoteDataSource {
  final DioClient _client;

  ChatsRemoteDataSource(this._client);
  Future<List<ChatsModel>> fetchChats() async {
    try {
      final response = await _client.get('/chats');

      // print('Response: ${response.data}');
      if (response.statusCode == 200) {
        return ChatsModel.fromResponse(response.data);
      } else {
        throw Exception('Failed to fetch the conversations');
      }
    } catch (e) {
      throw Exception('Error occured: ${e.toString()}');
    }
  }

  Future<List<Message>> fetchMessages(String chatId) async {
    try {
      final response = await _client.get('/message/$chatId');

      print('Response Messages: ${response.data}');
      if (response.statusCode == 200) {
        return Message.fromResponse(response.data);
      } else {
        throw Exception('Failed to fetch the messages');
      }
    } catch (e) {
      throw Exception('Error occured: ${e.toString()}');
    }
  }

  Future<AccessChat> accessChat(String userId) async {
    try {
      final response = await _client.post('/chats', data: {'userId': userId});

      print('Response Messages: ${response.data}');
      if (response.statusCode == 200) {
        return AccessChat.fromJson(response.data);
      } else {
        throw Exception('Failed to access chat');
      }
    } catch (e) {
      throw Exception('Error occured: ${e.toString()}');
    }
  }

  Future<GroupInfo> groupInfo(String groupId) async {
    try {
      final response =
          await _client.post('/chats/groupInfo', data: {'groupId': groupId});

      print('Response GroupInfo: ${response.data}');
      if (response.statusCode == 200) {
        return GroupInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to access GroupInfo');
      }
    } catch (e) {
      throw Exception('Error occured: ${e.toString()}');
    }
  }

  Future<bool> addMemberToGroup(String groupId, String userId) async {
    try {
      final response = await _client.put('/chats/addMember', data: {
        'groupId': groupId,
        'usersToAdd': [userId]
      });

      print('Response Add member to group: ${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Catch at data source');
      return false;
    }
  }
}
