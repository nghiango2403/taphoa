import 'package:flutter/material.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/features/navigation/presentation/data/nav_items.dart';

class MainNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const MainNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 5),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.white,
          elevation: 10,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          items: appNavItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
