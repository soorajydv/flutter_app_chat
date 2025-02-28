import 'dart:convert';
import 'dart:io';

import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/models/user_model.dart';
import 'package:amazetalk_flutter/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final AuthLocalDataSource cache;
  final DioClient client;

  final String baseUrl = "$BACKEND_URL/user";

  AuthRemoteDataSource(this.cache, this.client);

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
        final result = await UserModel.fromJson(jsonResponse);
        print('At repo: $result');
        await cache.save(result);
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
      String username, String email, String password, File? imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "name": username,
        "email": email,
        "password": password,
        if (imageFile != null)
          "image": await MultipartFile.fromFile(imageFile.path),
      });

      // final response = await http.post(Uri.parse('$baseUrl/register'),
      //     body: formData, headers: {"Content-Type": "multipart/form-data"}
      //     // options: Options(contentType: "multipart/form-data"),
      //     );

      final response = await client.post(
        '/user/register',
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = await UserModel.fromJson(response.data);
        print('At repo: $data');
        await cache.save(data);

        return data;
      } else {
        throw Exception('Failed to register: ${response.data}');
      }
    } catch (e) {
      throw Exception("Registration failed, please try again.");
    }
  }
}
