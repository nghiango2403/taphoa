import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountGet extends StatefulWidget {
  const AccountGet({super.key});

  @override
  State<AccountGet> createState() => _AccountGetState();
}

class _AccountGetState extends State<AccountGet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Thông tin tài khoản",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Họ tên",
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Số điện thoại",
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Ngày sinh",
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Địa chỉ",
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Giới tính",
                    ),
                    enabled: false,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.go("/taikhoan/edit"),
                    child: Text("Thay đổi thông tin"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go("/taikhoan/password"),
                    child: Text("Đổi mật khẩu"),
                  ),
                  ElevatedButton(
                    onPressed: () => print("Đăng xuất"),
                    child: Text("Đăng xuât"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
