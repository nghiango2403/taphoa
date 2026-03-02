import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taphoa/features/admin/khuyenmai/logic/khuyenmai_logic.dart';

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

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    _tenController = TextEditingController(text: widget.data['TenKhuyenMai']?.toString() ?? "");

    _startDate = widget.data['NgayBatDau'] != null ? DateTime.tryParse(widget.data['NgayBatDau'].toString()) : null;
    _endDate = widget.data['NgayKetThuc'] != null ? DateTime.tryParse(widget.data['NgayKetThuc'].toString()) : null;

    _batDauController = TextEditingController(
        text: _startDate != null ? _displayFormat.format(_startDate!) : ""
    );
    _ketThucController = TextEditingController(
        text: _endDate != null ? _displayFormat.format(_endDate!) : ""
    );

    String tienRaw = widget.data['TienKhuyenMai']?.toString() ?? "0";
    String dieuKienRaw = widget.data['DieuKien']?.toString() ?? "0";

    _tienController = TextEditingController(text: tienRaw.replaceAll(RegExp(r'[^0-9]'), ''));
    _dieuKienController = TextEditingController(text: dieuKienRaw.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _batDauController.text = _displayFormat.format(picked);
        } else {
          _endDate = picked;
          _ketThucController.text = _displayFormat.format(picked);
        }
      });
    }
  }

  void _handleUpdate() async {
    final logic = context.read<KhuyenMaiLogic>();
    final String id = widget.data['_id']?.toString() ?? "";

    if (id.isEmpty) {
      _showSnackBar("Không tìm thấy ID khuyến mãi");
      return;
    }

    final Map<String, dynamic> updateData = {
      "TenKhuyenMai": _tenController.text.trim(),
      "NgayBatDau": _startDate?.toIso8601String(),
      "NgayKetThuc": _endDate?.toIso8601String(),
      "TienKhuyenMai": int.tryParse(_tienController.text) ?? 0,
      "DieuKien": int.tryParse(_dieuKienController.text) ?? 0,
    };

    await logic.suaKhuyenMai(
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
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(),
              const SizedBox(height: 12),
              _buildInputLabel("Tên khuyến mãi"),
              _buildTextField(_tenController, "Nhập tên..."),
              const SizedBox(height: 12),
              _buildInputLabel("Ngày bắt đầu"),
              _buildTextField(_batDauController, "dd/mm/yyyy",
                  isReadOnly: true, icon: Icons.calendar_today, onTap: () => _selectDate(context, true)),
              const SizedBox(height: 12),
              _buildInputLabel("Ngày kết thúc"),
              _buildTextField(_ketThucController, "dd/mm/yyyy",
                  isReadOnly: true, icon: Icons.calendar_today, onTap: () => _selectDate(context, false)),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Sửa khuyến mãi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, bool isReadOnly = false, IconData? icon, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: icon != null ? Icon(icon, size: 18) : null,
        isDense: true,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer<KhuyenMaiLogic>(
        builder: (context, logic, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Huỷ", style: TextStyle(color: Colors.grey))),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: logic.isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: logic.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text("Lưu thay đổi", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        }
    );
  }
}