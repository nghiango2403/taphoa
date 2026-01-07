import 'package:flutter/material.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/core/widgets/custom_date_textfield.dart';

class AccountEdit extends StatefulWidget {
  const AccountEdit({super.key});

  @override
  State<AccountEdit> createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sửa thông tin tài khoản",
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
                labelText: "Họ tên",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Số điện thoại",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ngày sinh",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Địa chỉ",
              ),
            ),
            SizedBox(height: 10),
            CustomDateTextfield(
              label: "Chọn ngày",
              onDateSelect: (date) => print("Ngày đã chọn: $date"),
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
