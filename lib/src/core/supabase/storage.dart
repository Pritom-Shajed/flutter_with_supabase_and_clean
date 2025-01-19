import 'dart:io';

import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'helper.dart';

class SupabaseStorageApi {
  Future<String?> uploadFile(String bkt, String path, File file) async {
    try {
      final res = await sl<SupabaseClient>().storage.from(bkt).upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      log.i('Supabase photo upload in <$path> in $bkt: $res');
      return '$storageUrl/$res?lastUpdate=${DateTime.now().toUtc().millisecondsSinceEpoch}';
    } on SocketException catch (e) {
      log.e('No Internet Connection. $e');
      rethrow;
    } catch (e) {
      log.e('Supabase storage upload error: $e');
      rethrow;
    }
  }

  Future<void> remove(String bkt, String path) async {
    try {
      final storagePath = path.split('$storageUrl/').last.split('?').first;
      final res =
          await sl<SupabaseClient>().storage.from(bkt).remove([storagePath]);
      log.i('Supabase file removed from <$storagePath> in <$bkt>: $res');
    } on SocketException catch (e) {
      log.e('No Internet Connection. $e');
      throw 'No Internet Connection: $e';
    } catch (e) {
      log.e('Supabase storage remove error: $e');
      throw 'Supabase storage remove error: $e';
    }
  }
}
