import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/core/ultils/PopupItemModel.dart';
import 'package:taphoa/core/widgets/popupmenu.dart';

class AccountGet extends StatefulWidget {
  const AccountGet({super.key});

  @override
  State<AccountGet> createState() => _AccountGetState();
}

class _AccountGetState extends State<AccountGet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
          child: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Text(
                      "Thông tin tài khoản",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    CustomPopupMenu(
                      mainIcon: Icons.settings,
                      mainIconColor: Colors.blueGrey,
                      items: [
                        PopupItemModel(
                          id: 1,
                          title: "Chỉnh sửa",
                          icon: Icons.edit,
                        ),
                        PopupItemModel(
                          id: 2,
                          title: "Đổi mật khẩu",
                          icon: Icons.lock,
                        ),
                        PopupItemModel(
                          id: 3,
                          title: "Đăng xuất",
                          icon: Icons.logout,
                          color: Colors.red,
                        ),
                      ],
                      onSelected: (id) {
                        debugPrint("Selected item: $id");
                        switch (id) {
                          case 1:
                            context.go("/taikhoan/edit");
                            break;
                          case 2:
                            context.go("/taikhoan/password");
                            break;
                          case 3:
                            context.go("/taikhoan/logout");
                            break;
                          default:
                        }
                      },
                    ),
                  ],
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
        ),
      ),
    );
  }
}
