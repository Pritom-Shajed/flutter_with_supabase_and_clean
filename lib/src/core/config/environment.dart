import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  Environment._();
  static String get fileName => '.env';

  static String get devBaseUrl =>
      dotenv.env['DEV_BASE_URL'] ?? 'DEV_BASE_URL Not Found';

  static String get prodBaseUrl =>
      dotenv.env['PROD_BASE_URL'] ?? 'PROD_BASE_URL Not Found';

  static String get devAnonKey =>
      dotenv.env['DEV_ANON_KEY'] ?? 'DEV_ANON_KEY Not Found';

  static String get prodAnonKey =>
      dotenv.env['PROD_ANON_KEY'] ?? 'PROD_ANON_KEY Not Found';
}
