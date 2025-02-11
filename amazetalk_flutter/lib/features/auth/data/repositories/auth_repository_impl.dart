import 'package:amazetalk_flutter/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:amazetalk_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(
      String username, String email, String password) async {
    return await authRemoteDataSource.register(username, email, password);
  }
}
