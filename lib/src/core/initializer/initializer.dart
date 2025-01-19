import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_with_supabase/src/core/config/environment.dart';
import 'package:flutter_with_supabase/src/core/config/get_platform.dart';
import 'package:flutter_with_supabase/src/core/shared/error/error_view.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';

import '../utils/logger/logger.dart';

class Initializer {
  Initializer._();

  static void init(VoidCallback runApp) {
    ErrorWidget.builder = (errorDetails) {
      return ErrorView(
        message: errorDetails.exceptionAsString(),
      );
    };

    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details);
        log.i(details.stack.toString());
      };

      // Initialize Services
      await _initServices();
      runApp();
    }, (error, stack) {
      log.i('runZonedGuarded: ${error.toString()}');
    });
  }

  static Future<void> _initServices() async {
    try {
      _initScreenPreference();
      await dotenv.load(fileName: Environment.fileName);
      await initializeServiceLocator();
      if (sl<PT>().isWeb) setUrlStrategy(PathUrlStrategy());
    } catch (err) {
      rethrow;
    }
  }

  static void _initScreenPreference() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
