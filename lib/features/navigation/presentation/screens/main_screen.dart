import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/account/ui/account_get.dart';
import 'package:taphoa/features/admin/main/ui/admin_main_ui.dart';
import 'package:taphoa/features/navigation/presentation/business_logic/navigation_provider.dart';
import 'package:taphoa/features/navigation/presentation/widgets/main_navbar.dart';
import 'package:taphoa/features/staff/ui/product_get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NaVigationProvider(),
      child: Consumer<NaVigationProvider>(
        builder: (context, navProvider, child) {
          return Scaffold(
            body: IndexedStack(
              index: navProvider.currentIndex,
              children: const [ProductGet(), AdminMainUi(), AccountGet()],
            ),
            bottomNavigationBar: MainNavbar(
              currentIndex: navProvider.currentIndex,
              onTap: (index) {
                navProvider.changePage(index);
              },
            ),
          );
        },
      ),
    );
  }
}
