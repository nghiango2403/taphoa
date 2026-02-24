import 'package:flutter/material.dart';

class NhanvienThem extends StatefulWidget {
  const NhanvienThem({super.key});

  @override
  State<NhanvienThem> createState() => _NhanvienThemState();
}

class _NhanvienThemState extends State<NhanvienThem> {
  final _hoTenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _emailController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _matKhauController = TextEditingController();

  String? _gioiTinh = 'Nam';
  String? _chucVu;

  final List<String> _listChucVu = ['Quản lý', 'Nhân viên'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Thêm nhân viên mới",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputLabel("Họ và Tên"),
              _buildTextField(_hoTenController, "Nguyễn Văn A"),

              const SizedBox(height: 16),
              _buildInputLabel("Số điện thoại"),
              _buildTextField(_sdtController, "0909123456", isNumber: true),

              const SizedBox(height: 16),
              _buildInputLabel("Email"),
              _buildTextField(_emailController, "nguyenvana@example.com"),

              const SizedBox(height: 16),
              _buildInputLabel("Ngày sinh"),
              _buildDateField(_ngaySinhController),

              const SizedBox(height: 16),
              _buildInputLabel("Địa chỉ"),
              _buildTextField(
                _diaChiController,
                "123 Đường Lê Lợi, Quận 1, TP.HCM",
              ),

              const SizedBox(height: 16),
              _buildInputLabel("Giới tính"),
              Row(
                children: [
                  _buildRadioGioiTinh("Nam"),
                  _buildRadioGioiTinh("Nữ"),
                  _buildRadioGioiTinh("Khác"),
                ],
              ),

              const SizedBox(height: 16),
              _buildInputLabel("Mật khẩu"),
              _buildTextField(_matKhauController, "********", isPassword: true),

              const SizedBox(height: 16),
              _buildInputLabel("Chức vụ"),
              _buildDropdownChucVu(),

              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(
            () => controller.text =
                "${picked.day}/${picked.month}/${picked.year}",
          );
        }
      },
      decoration: InputDecoration(
        hintText: "dd/mm/yyyy",
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildRadioGioiTinh(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gioiTinh,
          onChanged: (val) => setState(() => _gioiTinh = val),
        ),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildDropdownChucVu() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _chucVu,
          hint: const Text("-- Chọn Chức Vụ --"),
          isExpanded: true,
          items: _listChucVu.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (val) => setState(() => _chucVu = val),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD166),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Lưu Nhân Viên",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
