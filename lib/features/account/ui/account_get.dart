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
    final info = accountLogic.accountData?.data;
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
                const SizedBox(height: 10),

                // 1. TRẠNG THÁI ĐANG TẢI
                if (accountLogic.isLoading)
                  const _LoadingView()
                // 2. TRẠNG THÁI LỖI (Thêm phần này)
                else if (accountLogic.errorMessage != null)
                  _ErrorView(
                    message: accountLogic.errorMessage!,
                    onRetry: () => accountLogic.fetchProfile(),
                  )
                // 3. TRẠNG THÁI HIỂN THỊ DATA
                else if (info != null)
                  _ProfileForm(info: info)
                // 4. TRƯỜNG HỢP TRỐNG (Nếu data null và không lỗi)
                else
                  const Text("Không có dữ liệu hiển thị."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Padding(
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
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Thử lại ngay"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  final dynamic info; // Truyền Model Data vào đây

  const _ProfileForm({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField("Họ tên", info.hoTen),
        _buildField("Email", info.email),
        _buildField("Số điện thoại", info.sdt),
        _buildField(
          "Ngày sinh",
          "${info.ngaySinh.day}/${info.ngaySinh.month}/${info.ngaySinh.year}",
        ),
        _buildField("Địa chỉ", info.diaChi),
        _buildField(
          "Giới tính",
          info.gioiTinh == "0" ? "Nam" : "Nữ",
        ), // Ví dụ logic hiển thị
      ],
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        // Dùng TextFormField hoặc TextField với initialValue
        initialValue: value,
        key: Key(value), // Thêm key để Flutter biết cần vẽ lại khi value đổi
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        readOnly: true, // Vì đây là màn hình xem thông tin
        enabled: false,
      ),
    );
  }
}
