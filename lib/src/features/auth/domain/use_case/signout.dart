import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';

class SignoutUseCase {
  final AuthRepository _repository;

  SignoutUseCase({required AuthRepository authRepository})
      : _repository = authRepository;

  Future<Either> call() async {
    return await _repository.signOut();
  }
}
