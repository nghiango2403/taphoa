import 'package:flutter/material.dart';

class KhuyenmaiSua extends StatefulWidget {
  final Map<String, dynamic> data;

  const KhuyenmaiSua({super.key, required this.data});

  @override
  State<KhuyenmaiSua> createState() => _KhuyenmaiSuaState();
}

class _KhuyenmaiSuaState extends State<KhuyenmaiSua> {
  late TextEditingController _tenController;
  late TextEditingController _batDauController;
  late TextEditingController _ketThucController;
  late TextEditingController _tienController;
  late TextEditingController _dieuKienController;

  @override
  void initState() {
    super.initState();
    _tenController = TextEditingController(text: widget.data['ten']);
    _batDauController = TextEditingController(text: widget.data['batDau']);
    _ketThucController = TextEditingController(text: widget.data['ketThuc']);
    _tienController = TextEditingController(
      text: widget.data['tien'].replaceAll(RegExp(r'[^0-9]'), ''),
    );
    _dieuKienController = TextEditingController(
      text: widget.data['dieuKien'].replaceAll(RegExp(r'[^0-9]'), ''),
    );
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
                    "Sửa khuyến mãi",
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

              _buildInputLabel("Tên khuyến mãi"),
              _buildTextField(_tenController, "Nhập tên..."),

              const SizedBox(height: 12),
              _buildInputLabel("Ngày bắt đầu"),
              _buildTextField(
                _batDauController,
                "dd/mm/yyyy",
                isReadOnly: true,
                icon: Icons.calendar_today,
              ),

              const SizedBox(height: 12),
              _buildInputLabel("Ngày kết thúc"),
              _buildTextField(
                _ketThucController,
                "dd/mm/yyyy",
                isReadOnly: true,
                icon: Icons.calendar_today,
              ),

              const SizedBox(height: 12),
              _buildInputLabel("Tiền khuyến mãi (đ)"),
              _buildTextField(_tienController, "0", isNumber: true),

              const SizedBox(height: 12),
              _buildInputLabel("Hoá đơn áp dụng trên (đ)"),
              _buildTextField(_dieuKienController, "0", isNumber: true),

              const SizedBox(height: 24),
              _buildActionButtons(),
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
    bool isReadOnly = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: icon != null ? Icon(icon, size: 18) : null,
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Huỷ", style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Lưu thay đổi",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
