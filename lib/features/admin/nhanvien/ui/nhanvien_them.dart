import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/data/logic/chucvu_logic.dart';
import 'package:taphoa/data/models/chucvu_model.dart';
import 'package:taphoa/features/admin/nhanvien/logic/NhanVienLogic.dart';

class NhanvienThem extends StatefulWidget {
  const NhanvienThem({super.key});

  @override
  State<NhanvienThem> createState() => _NhanvienThemState();
}

class _NhanvienThemState extends State<NhanvienThem> {
  final _formKey = GlobalKey<FormState>();

  final _hoTenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _emailController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _tenDangNhapController = TextEditingController();

  String _gioiTinhValue = "0";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChucVuLogic>().fetchChucVu();
      context.read<ChucVuLogic>().resetSelection();
    });
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _sdtController.dispose();
    _emailController.dispose();
    _ngaySinhController.dispose();
    _diaChiController.dispose();
    _matKhauController.dispose();
    _tenDangNhapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Thêm nhân viên mới",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel("Họ và Tên"),
                _buildTextField(_hoTenController, "Nguyễn Văn B", Icons.person),

                const SizedBox(height: 16),
                _buildInputLabel("Email"),
                _buildTextField(
                  _emailController,
                  "example@mail.com",
                  Icons.email,
                  isEmail: true,
                ),

                const SizedBox(height: 16),
                _buildInputLabel("Số điện thoại"),
                _buildTextField(
                  _sdtController,
                  "0909123456",
                  Icons.phone,
                  isNumber: true,
                ),

                const SizedBox(height: 16),
                _buildInputLabel("Địa chỉ"),
                _buildTextField(
                  _diaChiController,
                  "Số 123, đường...",
                  Icons.location_on,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Ngày sinh"),
                          _buildDateField(_ngaySinhController),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Giới tính"),
                          _buildDropdownGioiTinh(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildInputLabel("Mật khẩu"),
                _buildTextField(
                  _matKhauController,
                  "********",
                  Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 16),
                _buildInputLabel("Chức vụ"),
                _buildDropdownChucVu(),

                const SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber
          ? TextInputType.phone
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      validator: (value) {
        if (value == null || value.isEmpty) return "Không được để trống";
        if (isEmail &&
            !RegExp(
              r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ).hasMatch(value)) {
          return "Email không hợp lệ";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.indigo),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(1995),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {

          setState(
            () => controller.text =
                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}",
          );
        }
      },
      decoration: InputDecoration(
        hintText: "YYYY-MM-DD",
        prefixIcon: const Icon(
          Icons.calendar_month,
          size: 20,
          color: Colors.indigo,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdownGioiTinh() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gioiTinhValue,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: "0", child: Text("Nam")),
            DropdownMenuItem(value: "1", child: Text("Nữ")),
          ],
          onChanged: (val) => setState(() => _gioiTinhValue = val!),
        ),
      ),
    );
  }

  Widget _buildDropdownChucVu() {
    return Consumer<ChucVuLogic>(
      builder: (context, logic, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Datum>(
              value: logic.selectedChucVu,
              hint: const Text("-- Chọn Chức Vụ --"),
              isExpanded: true,
              items: logic.listChucVu.map((Datum item) {
                return DropdownMenuItem<Datum>(
                  value: item,
                  child: Text(item.tenChucVu),
                );
              }).toList(),
              onChanged: (val) => logic.setChucVu(val),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Consumer2<ChucVuLogic, NhanVienLogic>(
      builder: (context, cvLogic, nvLogic, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: nvLogic.isLoading
                ? null
                : () => _handleSave(cvLogic, nvLogic),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD166),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: nvLogic.isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text(
                    "LƯU NHÂN VIÊN",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _handleSave(ChucVuLogic cvLogic, NhanVienLogic nvLogic) async {
    if (_formKey.currentState!.validate()) {
      if (cvLogic.selectedChucVu == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn chức vụ!")));
        return;
      }

      final dataJson = {
        "HoTen": _hoTenController.text.trim(),
        "SDT": _sdtController.text.trim(),
        "Email": _emailController.text.trim(),
        "NgaySinh": _ngaySinhController.text,
        "DiaChi": _diaChiController.text.trim(),
        "GioiTinh": _gioiTinhValue,
        "MatKhau": _matKhauController.text,
        "MaChucVu": cvLogic.selectedChucVu!.id,
      };

      bool success = await nvLogic.addNhanVien(dataJson);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Thêm thành công!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(nvLogic.errorMessage ?? "Lỗi"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
