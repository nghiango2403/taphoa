import 'package:flutter/material.dart';

class AccountGet extends StatefulWidget {
  const AccountGet({super.key});

  @override
  State<AccountGet> createState() => _AccountGetState();
}

class _AccountGetState extends State<AccountGet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Tài khoản")));
  }
}
