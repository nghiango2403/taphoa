import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/hanghoa/logic/hanghoa_logic.dart';

class HanghoaSua extends StatefulWidget {
  final Map<String, dynamic> data;

  const HanghoaSua({super.key, required this.data});

  @override
  State<HanghoaSua> createState() => _HanghoaSuaState();
}

class _HanghoaSuaState extends State<HanghoaSua> {
  late TextEditingController _tenHangController;
  late TextEditingController _giaController;

  @override
  void initState() {
    super.initState();

    _tenHangController = TextEditingController(text: widget.data['Ten']?.toString() ?? "");

    String giaRaw = widget.data['Gia']?.toString() ?? "0";
    _giaController = TextEditingController(text: giaRaw.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  void _handleUpdate() async {
    final logic = context.read<HangHoaLogic>();
    final String id = widget.data['_id']?.toString() ?? "";

    if (id.isEmpty) {
      _showSnackBar("Lỗi: Không tìm thấy ID hàng hóa");
      return;
    }

    final Map<String, dynamic> updateData = {
      "Ten": _tenHangController.text.trim(),
      "Gia": int.tryParse(_giaController.text) ?? 0,
    };

    await logic.suaHangHoa(
      id,
      updateData,
      onSuccess: () {
        _showSnackBar("Cập nhật thành công!", isError: false);
        Navigator.pop(context);
      },
    );

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sửa hàng hoá", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            _buildInputLabel("Tên hàng hoá"),
            _buildTextField(_tenHangController, "Nhập tên hàng..."),

            const SizedBox(height: 16),
            _buildInputLabel("Giá bán (đ)"),
            _buildTextField(_giaController, "0", isNumber: true),

            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer<HangHoaLogic>(
      builder: (context, logic, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Huỷ", style: TextStyle(color: Colors.grey))),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: logic.isLoading ? null : _handleUpdate,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3)),
              child: logic.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text("Lưu thay đổi", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}