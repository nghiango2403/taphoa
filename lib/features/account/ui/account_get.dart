import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/core/ultils/PopupItemModel.dart';
import 'package:taphoa/core/widgets/popupmenu.dart';
import 'package:taphoa/features/account/logic/account_logic.dart';
import 'package:taphoa/features/auth/logic/auth_logic.dart';

class AccountGet extends StatefulWidget {
  const AccountGet({super.key});

  @override
  State<AccountGet> createState() => _AccountGetState();
}

class _AccountGetState extends State<AccountGet> {
  final _hotencontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _sdtcontroller = TextEditingController();
  final _ngaysinhcontroller = TextEditingController();
  final _diachicontroller = TextEditingController();
  final _gioitinhcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile();
    });
  }

  fetchProfile() async {
    final accountLogic = context.read<AccountLogic>();
    await accountLogic.fetchProfile();
    final info = accountLogic.accountData?.data;
    if (!mounted) return;
    if (info != null) {
      setState(() {
        _hotencontroller.text = info.hoTen;
        _emailcontroller.text = info.email;
        _sdtcontroller.text = info.sdt;
        _ngaysinhcontroller.text =
            "${info.ngaySinh.day}/${info.ngaySinh.month}/${info.ngaySinh.year}";
        _diachicontroller.text = info.diaChi;
        _gioitinhcontroller.text = info.gioiTinh;
      });
      print(info.hoTen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountLogic = context.watch<AccountLogic>();
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
                            {
                              final authLogic = context.read<AuthLogic>();
                              authLogic.logout();
                              break;
                            }

                          default:
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (accountLogic.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Đang tải thông tin..."),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Họ tên",
                        ),
                        enabled: false,
                        controller: _hotencontroller,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        enabled: false,
                        controller: _emailcontroller,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Số điện thoại",
                        ),
                        enabled: false,
                        controller: _sdtcontroller,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ngày sinh",
                        ),
                        enabled: false,
                        controller: _ngaysinhcontroller,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Địa chỉ",
                        ),
                        enabled: false,
                        controller: _diachicontroller,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Giới tính",
                        ),
                        enabled: false,
                        controller: _gioitinhcontroller,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
