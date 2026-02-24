import 'package:flutter/material.dart';

class PopupItemModel {
  final int id;
  final IconData icon;
  final String title;
  final Color? color;
  PopupItemModel({
    required this.id,
    required this.icon,
    required this.title,
    this.color,
  });
}
