import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/account/ui/account_edit.dart';
import 'package:taphoa/features/account/ui/account_edit_password.dart';
import 'package:taphoa/features/account/ui/account_get.dart';
import 'package:taphoa/features/admin/khuyenmai/ui/khuyenmai_them.dart';
import 'package:taphoa/features/admin/khuyenmai/ui/khuyenmai_tong.dart';
import 'package:taphoa/features/admin/main/ui/admin_main_ui.dart';
import 'package:taphoa/features/admin/nhanvien/ui/nhanvien_them.dart';
import 'package:taphoa/features/admin/nhanvien/ui/nhanvien_tong.dart';
import 'package:taphoa/features/admin/nhaphang/ui/nhaphang_them.dart';
import 'package:taphoa/features/admin/nhaphang/ui/nhaphang_them_hanghoa.dart';
import 'package:taphoa/features/admin/nhaphang/ui/nhaphang_tong.dart';
import 'package:taphoa/features/navigation/presentation/screens/main_screen.dart';
import 'package:taphoa/features/staff/ui/bill_add.dart';
import 'package:taphoa/features/staff/ui/product_add.dart';
import 'package:taphoa/routers/router_names.dart';

import '../features/auth/ui/login_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigator =
      GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    navigatorKey: _rootNavigator,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/",
                builder: (context, state) => BillAdd(),
                routes: [
                  GoRoute(
                    path: "product_add",
                    builder: (context, state) => ProductAdd(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/quanly",
                builder: (context, state) => const AdminMainUi(),
                routes: [
                  GoRoute(
                    path: "nhaphang",
                    builder: (context, state) => const NhaphangTong(),
                    routes: [
                      GoRoute(
                        path: "them",
                        builder: (context, state) => const NhaphangThem(),
                        routes: [
                          GoRoute(
                            path: "hanghoa",
                            builder: (context, state) => NhaphangThemHanghoa(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: "khuyenmai",
                    builder: (context, state) => const KhuyenmaiTong(),
                    routes: [
                      GoRoute(
                        path: "them",
                        builder: (context, state) => const KhuyenmaiThem(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: "nhanvien",
                    builder: (context, state) => const NhanvienTong(),
                    routes: [
                      GoRoute(
                        path: "them",
                        builder: (context, state) => const NhanvienThem(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/taikhoan",
                builder: (context, state) => const AccountGet(),
                routes: [
                  GoRoute(
                    path: "edit",
                    builder: (context, state) => AccountEdit(),
                  ),
                  GoRoute(
                    path: "password",
                    builder: (context, state) => AccountEditPassword(),
                  ),
                ],
              ),
            ],
          ),
        ],
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
