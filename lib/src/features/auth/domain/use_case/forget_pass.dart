import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/forget_password.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';

class ForgetPassUseCase {
  final AuthRepository _authRepository;

  ForgetPassUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Either> call({required ForgetPasswordParams params}) async {
    return await _authRepository.forgetPass(params: params);
  }
}
