import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String routerName;
  NavItem({required this.label, required this.icon, required this.routerName});
}

final List<NavItem> appNavItems = [
  NavItem(label: "Nhân viên", icon: Icons.person, routerName: "/"),
  NavItem(
    label: "Quản lý",
    icon: Icons.admin_panel_settings,
    routerName: "/quanly",
  ),
  NavItem(
    label: "Tài khoản",
    icon: Icons.account_circle,
    routerName: "/taikhoan",
  ),
];
