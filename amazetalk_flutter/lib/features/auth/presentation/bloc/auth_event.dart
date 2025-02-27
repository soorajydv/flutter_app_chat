import 'dart:io';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final File? imageFile;
  RegisterEvent(
      {required this.username,
      required this.email,
      required this.password,
      required this.imageFile});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

final class GetCacheData extends AuthEvent {}
