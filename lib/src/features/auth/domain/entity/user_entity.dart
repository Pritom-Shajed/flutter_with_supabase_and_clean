class UserEntity {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.createdAt,
      required this.updatedAt});
}
