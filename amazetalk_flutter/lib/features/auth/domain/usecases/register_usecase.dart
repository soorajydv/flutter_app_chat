import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:amazetalk_flutter/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<UserEntity> call(String username, String email, String password) {
    return (repository.register(username, email, password));
  }
}
