import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;

class AuthLocalDataSource {
  final _tokenKey = 'accessToken';
  final _idKey = 'id';

  final _nameKey = 'name';
  final _emailKey = 'email';
  final _avatarKey = 'avatar';

  Future<void> save(UserModel user) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString(_idKey, user.id);
    await storage.setString(_nameKey, user.name);
    await storage.setString(_emailKey, user.email);
    print('Storing image: ${user.image}');
    await storage.setString(_avatarKey, user.avatar);
    await storage.setString(_tokenKey, user.token);
  }

  Future<UserModel> getUser() async {
    final storage = await SharedPreferences.getInstance();
    final id = storage.getString(_idKey);
    final name = storage.getString(_nameKey);
    final email = storage.getString(_emailKey);
    final avatar = storage.getString(_avatarKey);
    print('Retrived image: $avatar');
    final token = storage.getString(_tokenKey);
    return UserModel(
        id: id ?? '',
        name: name ?? '',
        email: email ?? '',
        avatar: avatar ?? '',
        image: '',
        token: token ?? '');
  }

  Future<String?> getUserId() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(_idKey);
  }

// function to get and delete token
  Future<String?> getToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(_tokenKey);
  }

  Future<void> clear() async {
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
