import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signup.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase({required AuthRepository authRepository})
      : _repository = authRepository;

  Future<Either> call({required SignupParams params}) async {
    return _repository.signUp(params: params);
  }
}
