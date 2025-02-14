import 'dart:convert';
import 'package:amazetalk_flutter/features/conversation/data/models/conversation_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ConversationRemoteDataSource {
  final String baseUrl = 'http://localhost:3000';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: "token") ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/message/67ab40490cdc6dcf6bd68000/67ab40880cdc6dcf6bd68003'),
        headers: {
          'authorization': "bearer $token",
        });
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch the conversations');
    }
  }
}
