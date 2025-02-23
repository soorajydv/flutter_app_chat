class UserEntity {
  final String id;
  final String name;
  final String email;
  final String image;
  final String token;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.image = '',
    required this.token,
  });
}
