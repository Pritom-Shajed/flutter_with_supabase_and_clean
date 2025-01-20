class SignupParams {
  final String email;
  final String name;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  SignupParams({
    required this.email,
    required this.name,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      _Json.email: email,
      _Json.name: name,
      _Json.pass: password,
      _Json.createdAt: createdAt.toUtc().toIso8601String(),
      _Json.updatedAt: updatedAt.toUtc().toIso8601String(),
    };
  }
}

class _Json {
  static const String email = 'email';
  static const String name = 'name';
  static const String pass = 'password';
  static const String createdAt = 'created';
  static const String updatedAt = 'updated';
}
