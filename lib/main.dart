import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_with_supabase/src/app.dart';
import 'package:flutter_with_supabase/src/core/initializer/initializer.dart';
import 'package:flutter_with_supabase/src/core/utils/theme/themes.dart';

void main() {
  Initializer.init(() => runApp(ProviderScope(child: const MyApp())));
}

void configEasyLoading(BuildContext context) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..boxShadow = const <BoxShadow>[]
    ..indicatorColor = kPrimaryColor
    ..progressColor = kPrimaryColor
    ..textColor = Colors.white
    ..textStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    )
    ..dismissOnTap = false
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.black.withValues(alpha: 0.8)
    ..indicatorWidget = const SizedBox(
      height: 70.0,
      width: 70.0,
      child: SpinKitThreeBounce(color: white, size: 30.0),
    )
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
}
