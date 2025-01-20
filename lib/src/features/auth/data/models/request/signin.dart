class SigninParams {
  final String email;
  final String password;

  SigninParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      _Json.email: email,
      _Json.pass: password,
    };
  }
}

class _Json {
  static const String email = 'email';
  static const String pass = 'password';
}
