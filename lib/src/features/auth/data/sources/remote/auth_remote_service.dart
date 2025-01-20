import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/forget_password.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/data/models/request/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteService {
  Future<Either> signIn({required SigninParams params});
  Future<Either> signUp({required SignupParams params});
  Future<Either> forgetPass({required ForgetPasswordParams params});
  Future<Either> signOut();
}

class AuthRemoteServiceImpl implements AuthRemoteService {
  final SupabaseClient _supabaseClient;

  AuthRemoteServiceImpl({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  @override
  Future<Either> signUp({required SignupParams params}) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
        data: {
          'email': params.email,
          'name': params.name,
          'phone': params.phone,
          'avatar': null,
          'created': params.createdAt.toUtc().toIso8601String(),
          'updated': params.updatedAt.toUtc().toIso8601String(),
        },
      );
      return Right(response);
    } on SocketException catch (e) {
      log.e('signup error: No internet connection. $e');
      return Left('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      log.e('signup error: $e');
      return Left(e.message);
    } catch (e) {
      log.e('signup error: $e');
      return Left(e);
    }
  }

  @override
  Future<Either> signIn({required SigninParams params}) async {
    try {
      final response = await _supabaseClient.auth
          .signInWithPassword(email: params.email, password: params.password);

      return Right(response);
    } on SocketException catch (e) {
      log.e('signin error: No internet connection. $e');
      return Left('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      log.e('signin error: $e');
      return Left(e.message);
    } catch (e) {
      log.e('signin error: $e');
      return Left(e);
    }
  }

  @override
  Future<Either> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      log.i('Signout successful');
      return Right('Sign out successful.');
    } on SocketException catch (e) {
      log.e('signout error: No internet connection. $e');
      return Left('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      log.e('signout error: $e');
      return Left(e.message);
    } catch (e) {
      log.e('signout error: $e');
      return Left(e);
    }
  }

  @override
  Future<Either> forgetPass({required ForgetPasswordParams params}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(params.email);

      log.i('Password reset email sent.');
      return Right('Password reset email sent.');
    } on SocketException catch (e) {
      log.e('forget password error: No internet connection. $e');
      return Left('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      log.e('forget password error: $e');
      return Left(e.message);
    } catch (e) {
      log.e('forget password error: $e');
      return Left(e);
    }
  }
}
