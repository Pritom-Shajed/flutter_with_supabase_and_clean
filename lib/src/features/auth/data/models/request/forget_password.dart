class ForgetPasswordParams {
  final String email;

  ForgetPasswordParams({required this.email});

  Map<String, dynamic> toJson() {
    return {
      _Json.email: email,
    };
  }
}

class _Json {
  static const String email = 'email';
}
