import 'package:flutter_with_supabase/src/core/config/get_platform.dart';
import 'package:flutter_with_supabase/src/core/supabase/init.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  sl.registerSingleton<PT>(PlatformInfo.getCurrentPlatformType());
  sl.registerSingleton<SupabaseClient>(await initSupabase());
}
