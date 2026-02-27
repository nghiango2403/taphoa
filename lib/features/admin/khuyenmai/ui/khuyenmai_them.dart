import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/khuyenmai/logic/khuyenmai_logic.dart'; // Thay đổi path cho đúng project của bạn

class KhuyenmaiThem extends StatefulWidget {
  const KhuyenmaiThem({super.key});

  @override
  State<KhuyenmaiThem> createState() => _KhuyenmaiThemState();
}

class _KhuyenmaiThemState extends State<KhuyenmaiThem> {
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _batDauController = TextEditingController();
  final TextEditingController _ketThucController = TextEditingController();
  final TextEditingController _tienController = TextEditingController();
  final TextEditingController _dieuKienController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  // Hàm chọn ngày và lưu vào biến DateTime
  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      bool isStartDate,
      ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Hàm xử lý khi nhấn Lưu
  void _handleSave() async {
    final logic = context.read<KhuyenMaiLogic>();

    // 1. Validation cơ bản
    if (_tenController.text.isEmpty || _startDate == null || _endDate == null) {
      _showSnackBar("Vui lòng điền đầy đủ thông tin bắt buộc");
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showSnackBar("Ngày kết thúc phải sau ngày bắt đầu");
      return;
    }

    // 2. Chuẩn bị dữ liệu
    final Map<String, dynamic> data = {
      "TenKhuyenMai": _tenController.text.trim(),
      "NgayBatDau": _startDate!.toIso8601String(),
      "NgayKetThuc": _endDate!.toIso8601String(),
      "TienKhuyenMai": int.tryParse(_tienController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      "DieuKien": int.tryParse(_dieuKienController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
    };

    // 3. Gọi Logic xử lý
    FocusScope.of(context).unfocus(); // Ẩn bàn phím
    await logic.themKhuyenMai(
      data,
      onSuccess: () {
        _showSnackBar("Thêm khuyến mãi thành công!", isError: false);
        Navigator.pop(context); // Quay lại trang danh sách
      },
    );

    // 4. Hiển thị lỗi nếu có từ server
    if (logic.errorMessage != null) {
      _showSnackBar(logic.errorMessage!);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Thêm khuyến mãi", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel("Tên khuyến mãi *"),
                _buildTextField(_tenController, "Nhập tên chương trình..."),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Ngày bắt đầu *"),
                          _buildDateField(_batDauController, () => _selectDate(context, _batDauController, true)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Ngày kết thúc *"),
                          _buildDateField(_ketThucController, () => _selectDate(context, _ketThucController, false)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildInputLabel("Tiền khuyến mãi (đ)"),
                _buildTextField(_tienController, "0", isNumber: true),

                const SizedBox(height: 16),
                _buildInputLabel("Hoá đơn áp dụng trên (đ)"),
                _buildTextField(_dieuKienController, "0", isNumber: true),

                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Các Widget thành phần giữ nguyên style của bạn ---
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, VoidCallback onTap) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "dd/mm/yyyy",
        suffixIcon: const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Huỷ", style: TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Consumer<KhuyenMaiLogic>(
            builder: (context, logic, child) {
              return ElevatedButton(
                onPressed: logic.isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: logic.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Lưu khuyến mãi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
      ],
    );
  }
}