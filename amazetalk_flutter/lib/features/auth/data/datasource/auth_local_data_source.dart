import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;

class AuthLocalDataSource {
  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'accessToken';
  final _idKey = 'id';

  final _nameKey = 'name';
  final _emailKey = 'email';
  final _avatarKey = 'avatar';

  Future<void> save(UserModel user) async {
    await _storage.write(key: _idKey, value: user.id);
    await _storage.write(key: _nameKey, value: user.name);
    await _storage.write(key: _emailKey, value: user.email);
    await _storage.write(key: _avatarKey, value: user.image);
    await _storage.write(key: _tokenKey, value: user.token);
  }

  Future<UserModel> getUser() async {
    final id = await _storage.read(key: _idKey);
    final name = await _storage.read(key: _nameKey);
    final email = await _storage.read(key: _emailKey);
    final image = await _storage.read(key: _avatarKey);
    final token = await _storage.read(key: _tokenKey);
    return UserModel(
        id: id,
        name: name,
        email: email,
        image: image ?? '',
        token: token ?? '');
  }

  Future<String?> getUserId() => _storage.read(key: _idKey);

// function to get and delete token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clear() async {
    await _storage.delete(key: _idKey);
    await _storage.delete(key: _nameKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _avatarKey);
    await _storage.delete(key: _tokenKey);
  }
}
