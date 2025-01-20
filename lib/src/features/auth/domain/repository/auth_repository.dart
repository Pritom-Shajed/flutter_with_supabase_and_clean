import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/forget_password.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signup.dart';

abstract class AuthRepository {
  Future<Either> signIn({required SigninParams params});
  Future<Either> signUp({required SignupParams params});
  Future<Either> forgetPass({required ForgetPasswordParams params});
  Future<Either> signOut();
}
