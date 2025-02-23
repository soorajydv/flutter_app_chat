import 'dart:convert';

import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final AuthLocalDataSource cache;

  final String baseUrl = "$BACKEND_URL/user";

  AuthRemoteDataSource(this.cache);

  Future<UserModel> login(String name, String password) async {
    print('Proceed to login');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'name': name, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      // print('Response: .....$response');
      // ✅ Check for HTTP response status
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // ✅ Check if user and token exist
        final result = UserModel.fromJson(jsonResponse);
        cache.save(result);
        return result;
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
      print('error: $e');
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
        cache.save(data);

        return data;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception("Registration failed, please try again.");
    }
  }
}
