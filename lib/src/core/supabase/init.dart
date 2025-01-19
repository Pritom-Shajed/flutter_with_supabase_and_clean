import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/environment.dart';

final authStreamPd =
    StreamProvider((_) => sl<SupabaseClient>().auth.onAuthStateChange);

Future<SupabaseClient> initSupabase() async {
  log.i('Supabase Dev Url: ${Environment.devBaseUrl}');
  log.i('Supabase Dev Anon Key: ${Environment.devAnonKey}');
  log.i('Supabase Prod Url: ${Environment.prodBaseUrl}');
  log.i('Supabase Prod Anon Key: ${Environment.prodAnonKey}');
  final supabase = await Supabase.initialize(
    debug: true,
    url: Environment.devBaseUrl,
    anonKey: Environment.devAnonKey,
  );
  log.i('Supabase initialized: ${supabase.client.auth.currentUser}');
  return supabase.client;
}
