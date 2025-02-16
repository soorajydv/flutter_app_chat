import 'dart:convert';
import 'package:amazetalk_flutter/constant.dart';
import 'package:amazetalk_flutter/features/conversation/data/models/conversation_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/messages_model.dart';

class ConversationRemoteDataSource {
  final _storage = FlutterSecureStorage();

  Future<ConversationModel> fetchConversations() async {
    String token = await _storage.read(key: "token") ?? "";
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
    String token = await _storage.read(key: "token") ?? "";
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
}
