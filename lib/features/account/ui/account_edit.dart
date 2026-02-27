import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/core/widgets/custom_date_textfield.dart';
import 'package:taphoa/features/account/logic/account_logic.dart';

class AccountEdit extends StatefulWidget {
  const AccountEdit({super.key});

  @override
  State<AccountEdit> createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  final _hotenController = TextEditingController();
  final _emailController = TextEditingController();
  final _sdtController = TextEditingController();
  final _ngaysinhController = TextEditingController();
  final _diachiController = TextEditingController();

  // Biến lưu giá trị giới tính đã chọn
  String? _selectedGioiTinh;

  @override
  void initState() {
    super.initState();
    // Sử dụng WidgetsBinding để đảm bảo context đã sẵn sàng sau khi frame đầu tiên được dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile();
    });
  }

  void fetchProfile() {
    final accountLogic = context.read<AccountLogic>();
    final info = accountLogic.accountData?.data;

    if (info != null) {
      _hotenController.text = info.hoTen;
      _emailController.text = info.email;
      _sdtController.text = info.sdt;
      _ngaysinhController.text = DateFormat('dd/MM/yyyy').format(info.ngaySinh);
      _diachiController.text = info.diaChi;

      String rawGioiTinh = info.gioiTinh.toString();
      if (rawGioiTinh == "0" || rawGioiTinh == "1") {
        _selectedGioiTinh = rawGioiTinh;
      } else {
        _selectedGioiTinh = null; // Trả về null để tránh crash Dropdown
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _hotenController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    _ngaysinhController.dispose();
    _diachiController.dispose();
    super.dispose();
  }

  void _onSavePressed() async {
    if (_hotenController.text.trim().isEmpty ||
        _sdtController.text.trim().isEmpty) {
      _showSnackBar("Vui lòng nhập Họ tên và Số điện thoại", Colors.orange);
      return;
    }

    final accountLogic = context.read<AccountLogic>();

    try {
      DateTime birthDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(_ngaysinhController.text);

      final data = {
        "HoTen": _hotenController.text.trim(),
        "SDT": _sdtController.text.trim(),
        "Email": _emailController.text.trim(),
        "NgaySinh": birthDate.toIso8601String(),
        "DiaChi": _diachiController.text.trim(),
        "GioiTinh":
            _selectedGioiTinh ?? "0", // Nếu chưa chọn thì mặc định gửi 0 (Nam)
      };

      await accountLogic.updateProfile(data);

      if (!mounted) return;
      _showSnackBar("Cập nhật thông tin thành công!", Colors.green);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Lỗi dữ liệu: Vui lòng kiểm tra lại", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountLogic = context.watch<AccountLogic>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sửa thông tin tài khoản",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Họ tên", _hotenController, Icons.person),
            const SizedBox(height: 15),
            _buildTextField("Email", _emailController, Icons.email),
            const SizedBox(height: 15),
            _buildTextField("Số điện thoại", _sdtController, Icons.phone),
            const SizedBox(height: 15),

            // DROP-DOWN GIỚI TÍNH
            DropdownButtonFormField<String>(
              value: _selectedGioiTinh,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Giới tính",
                prefixIcon: Icon(Icons.wc),
              ),
              hint: const Text("Chọn giới tính"),
              items: const [
                DropdownMenuItem(value: "0", child: Text("Nam")),
                DropdownMenuItem(value: "1", child: Text("Nữ")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGioiTinh = value;
                });
              },
            ),

            const SizedBox(height: 15),
            _buildTextField("Địa chỉ", _diachiController, Icons.location_on),
            const SizedBox(height: 15),

            CustomDateTextfield(
              label: "Ngày sinh",
              controller: _ngaysinhController,
              onDateSelect: (date) {},
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: accountLogic.isLoading ? null : _onSavePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primaryColor.withOpacity(
                    0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: accountLogic.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "LƯU THÔNG TIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
