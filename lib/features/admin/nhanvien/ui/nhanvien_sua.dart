import 'package:flutter/material.dart';

class NhanvienSua extends StatefulWidget {
  final Map<String, dynamic> data;

  const NhanvienSua({super.key, required this.data});

  @override
  State<NhanvienSua> createState() => _NhanvienSuaState();
}

class _NhanvienSuaState extends State<NhanvienSua> {
  late TextEditingController _hoTenController;
  late TextEditingController _sdtController;
  late TextEditingController _emailController;
  late TextEditingController _ngaySinhController;
  late TextEditingController _diaChiController;

  String? _gioiTinh;
  String? _chucVu;
  final List<String> _listChucVu = ['Quản lý', 'Nhân viên'];

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: widget.data['name']);
    _sdtController = TextEditingController(
      text: widget.data['sdt'] ?? "0912345678",
    );
    _emailController = TextEditingController(
      text: widget.data['email'] ?? "nguyenvana@example.com",
    );
    _ngaySinhController = TextEditingController(
      text: widget.data['ngaySinh'] ?? "15/05/1990",
    );
    _diaChiController = TextEditingController(
      text: widget.data['diaChi'] ?? "123 Đường Lê Lợi",
    );
    _gioiTinh = widget.data['gioiTinh'] ?? 'Nữ';
    _chucVu = widget.data['role'] ?? 'Quản lý';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sửa Thông Tin Nhân Viên",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              _buildInputLabel("Họ và Tên"),
              _buildTextField(_hoTenController, "Nhập họ tên..."),

              const SizedBox(height: 12),
              _buildInputLabel("Số Điện Thoại"),
              _buildTextField(_sdtController, "09...", isNumber: true),

              const SizedBox(height: 12),
              _buildInputLabel("Email"),
              _buildTextField(_emailController, "example@mail.com"),

              const SizedBox(height: 12),
              _buildInputLabel("Ngày Sinh"),
              _buildDateField(_ngaySinhController),

              const SizedBox(height: 12),
              _buildInputLabel("Địa Chỉ"),
              _buildTextField(_diaChiController, "Địa chỉ..."),

              const SizedBox(height: 12),
              _buildInputLabel("Giới Tính"),
              Row(
                children: [
                  _buildRadioGioiTinh("Nam"),
                  _buildRadioGioiTinh("Nữ"),
                  _buildRadioGioiTinh("Khác"),
                ],
              ),

              const SizedBox(height: 12),
              _buildInputLabel("Chức Vụ"),
              _buildDropdownChucVu(),

              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: Colors.grey[50],
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
          initialDate: DateTime(1990, 5, 15),
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
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        isDense: true,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _chucVu,
          isExpanded: true,
          items: _listChucVu
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _chucVu = val),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEAA7),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Lưu Thay Đổi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
