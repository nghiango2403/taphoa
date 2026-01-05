import 'package:flutter/material.dart';

class AdminMainUi extends StatefulWidget {
  const AdminMainUi({super.key});

  @override
  State<AdminMainUi> createState() => _AdminMainUiState();
}

class _AdminMainUiState extends State<AdminMainUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Quản lý")));
  }
}
