import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/forget_password.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signup.dart';
import 'package:flutter_with_supabase/src/features/auth/data/sources/remote/auth_remote_service.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteService _authRemoteService;

  AuthRepositoryImpl({required AuthRemoteService authRemoteService})
      : _authRemoteService = authRemoteService;
  @override
  Future<Either> forgetPass({required ForgetPasswordParams params}) async {
    final response = await _authRemoteService.forgetPass(params: params);
    return response.fold((error) {
      return Left(error);
    }, (success) {
      return Right(success);
    });
  }

  @override
  Future<Either> signIn({required SigninParams params}) async {
    final response = await _authRemoteService.signIn(params: params);
    return response.fold((error) {
      return Left(error);
    }, (success) {
      return Right(success);
    });
  }

  @override
  Future<Either> signOut() async {
    final response = await _authRemoteService.signOut();

    return response.fold((error) {
      return Left(error);
    }, (success) {
      return Right(success);
    });
  }

  @override
  Future<Either> signUp({required SignupParams params}) async {
    final response = await _authRemoteService.signUp(params: params);

    return response.fold((error) {
      return Left(error);
    }, (success) {
      return Right(success);
    });
  }
}
