import 'package:flutter/material.dart';
import 'package:taphoa/core/theme/app_colors.dart';

class AccountEditPassword extends StatefulWidget {
  const AccountEditPassword({super.key});

  @override
  State<AccountEditPassword> createState() => _AccountEditPasswordState();
}

class _AccountEditPasswordState extends State<AccountEditPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đổi mật khẩu",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mật khẩu cũ",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mật khẩu mới",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nhập lại mật khẩu mới",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => print("Lưu"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text("Lưu", style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
