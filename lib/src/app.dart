import 'package:flutter/material.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/core/utils/theme/light/light_theme.dart';
import 'package:flutter_with_supabase/src/features/home/presentation/view/home_view.dart';
import 'package:flutter_with_supabase/src/features/internet/view/internet_view.dart';
import 'core/router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../main.dart';
import 'core/config/constants.dart' show appName;
import 'core/config/size.dart';
import 'core/utils/extensions/extensions.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key = const Key(appName)});

  @override
  Widget build(BuildContext context) {
    configEasyLoading(context);
    return MaterialApp.router(
      title: appName,
      theme: lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: appName.toCamelWord,
      builder: EasyLoading.init(builder: (ctx, child) {
        topBarSize = ctx.padding.top;
        bottomViewPadding = ctx.padding.bottom;
        log.i('App build. Height: ${ctx.height} px, Width: ${ctx.width} px');
        return MediaQuery(
          data: ctx.mq.copyWith(
            devicePixelRatio: 1.0,
            textScaler: const TextScaler.linear(1.0),
          ),
          child: InternetView(child: child ?? const HomeView()),
        );
      }),
    );
  }
}
