import 'dart:convert';

import 'package:amazetalk_flutter/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = "http://localhost:3000/auth";

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      // ✅ Check for HTTP response status
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // ✅ Check if user and token exist
        if (jsonResponse.containsKey('user') &&
            jsonResponse.containsKey('token')) {
          return UserModel.fromJson(jsonResponse);
        } else {
          throw Exception("Invalid response format. Missing user or token.");
        }
      } else if (response.statusCode == 400) {
        throw Exception(
            "Invalid credentials. Please check your email and password.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
            "Unexpected error. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<UserModel> register(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: jsonEncode(
            {"username": username, "email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        UserModel data = UserModel.fromJson(jsonDecode(response.body)["user"]);

        return data;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception("Registration failed, please try again.");
    }
  }
}
