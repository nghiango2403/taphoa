import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/navigation/presentation/screens/main_screen.dart';
import 'package:taphoa/routers/router_names.dart';

import '../features/auth/ui/login_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RouterNames.home,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: RouterNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 - Page not found'))),
  );
}
