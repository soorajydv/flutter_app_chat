import 'dart:convert';

import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/features/conversation/data/models/conversation_model.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/messages_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/messages_model.dart';

class ConversationRemoteDataSource {
  Future<ConversationModel> fetchConversations() async {
    final _storage = await SharedPreferences.getInstance();

    String token = await _storage.getString("token") ?? "";
    final response =
        await http.get(Uri.parse('$BACKEND_URL/conversations'), headers: {
      'authorization': "bearer $token",
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ConversationModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch the conversations');
    }
  }

  Future<MessagesModel> fetchMessages(String conversationId) async {
    final _storage = await SharedPreferences.getInstance();
    String token = await _storage.getString("token") ?? "";
    final response = await http
        .get(Uri.parse('$BACKEND_URL/message/$conversationId'), headers: {
      'authorization': "bearer $token",
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MessagesModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch the conversations');
    }
  }

  Future<bool> sendMessage(SendMessageEntity message) async {
    final _storage = await SharedPreferences.getInstance();
    String token = _storage.getString("token") ?? "";
    final url = Uri.parse('$BACKEND_URL/message/send');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'authorization': "bearer $token",
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to send message");
    }
  }
}
