class UserEntity {
  final String id;
  final String username;
  final String email;
  final String token;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.token = " ",
  });
}
