import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';

class SigninUseCase {
  final AuthRepository _repository;

  SigninUseCase({required AuthRepository authRepository})
      : _repository = authRepository;

  Future<Either> call({required SigninParams params}) async {
    return await _repository.signIn(params: params);
  }
}
