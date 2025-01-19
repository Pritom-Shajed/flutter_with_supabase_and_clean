import 'package:flutter/material.dart';
import 'package:flutter_with_supabase/src/core/shared/page_not_found/page_not_found.dart';
import 'package:flutter_with_supabase/src/core/utils/logger/logger.dart';
import 'package:flutter_with_supabase/src/features/auth/presentation/view/sign_in_view.dart';
import 'package:flutter_with_supabase/src/features/auth/presentation/view/sign_up_view.dart';
import 'package:flutter_with_supabase/src/features/home/presentation/view/home_view.dart';
import 'package:flutter_with_supabase/src/features/maintenace/presentation/view/maintenance_break.dart';
import 'package:flutter_with_supabase/src/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/get_platform.dart';
import 'app_routes.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: AppRoutes.homeRoute,
  errorBuilder: (_, __) => const KPageNotFound(error: '404 - Page not found!'),
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.homeRoute,
      name: HomeView.name,
      builder: (_, __) => const HomeView(),
    ),
    GoRoute(
      path: AppRoutes.signinRoute,
      name: SignInView.name,
      builder: (_, __) => const SignInView(),
    ),
    GoRoute(
      path: AppRoutes.signupRoute,
      name: SignUpView.name,
      builder: (_, __) => const SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.maintenanceBreakRoute,
      name: MaintenanceBreakView.name,
      builder: (_, __) => const MaintenanceBreakView(),
    ),
  ],
  redirect: (context, state) {
    final path = '/${state.fullPath?.split('/').last.toLowerCase()}';
    final loggedIn = sl<SupabaseClient>().auth.currentUser != null;
    log.f('Path: $path');

    /// Maintenance Break
    if (AppRoutes.isMaintenanceBreak) {
      log.f(
          'Redirecting to ${AppRoutes.maintenanceBreakRoute} from $path Reason: Maintenance Break.');
      return AppRoutes.maintenanceBreakRoute;
    }
    if (!AppRoutes.isMaintenanceBreak &&
        path == AppRoutes.maintenanceBreakRoute) {
      log.f(
          'Redirecting to ${AppRoutes.homeRoute} from $path Reason: Maintenance Break ended.');
      return AppRoutes.homeRoute;
    }

    /// Auth
    if (!loggedIn && AppRoutes.allAuthRequiredRoutes.contains(path)) {
      log.f(
          'Redirecting to ${AppRoutes.signinRoute} from $path Reason: Authentication.');
      return AppRoutes.signinRoute;
    }
    if (loggedIn && AppRoutes.authRelatedRoutes.contains(path)) {
      log.f(
          'Redirecting to ${AppRoutes.homeRoute} from $path Reason: Already logged in.');
      return AppRoutes.homeRoute;
    }
    return null;
  },
);

extension GoRouteExtension on BuildContext {
  goPush<T>(String route, {Object? extra}) => sl<PT>().isWeb
      ? GoRouter.of(this).go(route, extra: extra)
      : GoRouter.of(this).push(route, extra: extra);
}
