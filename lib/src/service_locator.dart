import 'package:flutter_with_supabase/src/core/config/get_platform.dart';
import 'package:flutter_with_supabase/src/core/supabase/init.dart';
import 'package:flutter_with_supabase/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_with_supabase/src/features/auth/data/sources/remote/auth_remote_service.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/forget_pass.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signin.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signout.dart';
import 'package:flutter_with_supabase/src/features/auth/domain/use_case/signup.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  sl.registerSingleton<PT>(PlatformInfo.getCurrentPlatformType());
  sl.registerSingleton<SupabaseClient>(await initSupabase());

  // Services
  sl.registerSingleton<AuthRemoteService>(AuthRemoteServiceImpl(
    supabaseClient: sl<SupabaseClient>(),
  ));

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    authRemoteService: sl<AuthRemoteService>(),
  ));

  // UseCases
  sl.registerSingleton<SigninUseCase>(SigninUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  sl.registerSingleton<SignupUseCase>(SignupUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  sl.registerSingleton<SignoutUseCase>(SignoutUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  sl.registerSingleton<ForgetPassUseCase>(ForgetPassUseCase(
    authRepository: sl<AuthRepository>(),
  ));
}
