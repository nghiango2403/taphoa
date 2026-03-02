import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/nhanvien/logic/NhanVienLogic.dart';

class NhanvienSua extends StatefulWidget {
  final String nhanVienId;

  const NhanvienSua({super.key, required this.nhanVienId});

  @override
  State<NhanvienSua> createState() => _NhanvienSuaState();
}

class _NhanvienSuaState extends State<NhanvienSua> {

  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _diaChiController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  String? _gioiTinh;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    final logic = context.read<NhanVienLogic>();
    bool success = await logic.fetchChiTietNhanVien(widget.nhanVienId);

    if (success && logic.nhanVienChiTiet != null) {
      final chiTiet = logic.nhanVienChiTiet!.data.maNhanSu;
      setState(() {
        _hoTenController.text = chiTiet.hoTen;
        _sdtController.text = chiTiet.sdt;
        _emailController.text = chiTiet.email;
        _diaChiController.text = chiTiet.diaChi;

        _ngaySinhController.text = chiTiet.ngaySinh.toIso8601String().split(
          'T',
        )[0];
        _gioiTinh = chiTiet.gioiTinh;
      });
    }
  }

  void _handleUpdate() async {
    final logic = context.read<NhanVienLogic>();

    final Map<String, dynamic> updateData = {
      "MaNhanSu": logic.nhanVienChiTiet?.data.maNhanSu.id,
      "HoTen": _hoTenController.text.trim(),
      "SDT": _sdtController.text.trim(),
      "Email": _emailController.text.trim(),
      "NgaySinh": _ngaySinhController.text.trim(),
      "DiaChi": _diaChiController.text.trim(),
      "GioiTinh": _gioiTinh,
    };

    bool success = await logic.updateNhanVien(updateData);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật thành công!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Consumer<NhanVienLogic>(
        builder: (context, logic, child) {

          if (logic.isLoading && logic.nhanVienChiTiet == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(),

                  _buildInputLabel("Họ và Tên"),
                  _buildTextField(_hoTenController, "Họ tên"),

                  _buildInputLabel("Số điện thoại"),
                  _buildTextField(
                    _sdtController,
                    "Số điện thoại",
                    keyboardType: TextInputType.phone,
                  ),

                  _buildInputLabel("Email"),
                  _buildTextField(_emailController, "Email"),

                  _buildInputLabel("Ngày sinh"),
                  _buildTextField(_ngaySinhController, "YYYY-MM-DD"),

                  _buildInputLabel("Địa chỉ"),
                  _buildTextField(_diaChiController, "Địa chỉ"),

                  _buildInputLabel("Giới Tính"),
                  Row(
                    children: [
                      _buildRadioGioiTinh("Nam", "1"),
                      _buildRadioGioiTinh("Nữ", "0"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  logic.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSaveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Sửa Nhân Viên",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRadioGioiTinh(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gioiTinh,
          onChanged: (val) => setState(() => _gioiTinh = val),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "CẬP NHẬT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
