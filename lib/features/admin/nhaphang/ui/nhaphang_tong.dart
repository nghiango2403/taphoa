import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/admin/nhaphang/ui/nhaphang_xem.dart';

class NhaphangTong extends StatefulWidget {
  const NhaphangTong({super.key});

  @override
  State<NhaphangTong> createState() => _NhaphangTongState();
}

class _NhaphangTongState extends State<NhaphangTong> {
  final List<String> danhSachNhap = List.generate(
    20,
    (index) => "09:09:47 23/8/2025",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Quản lý nhập hàng",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeaderActions(context),
              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          itemCount: danhSachNhap.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return _buildTableRow(
                              stt: (index + 1).toString(),
                              thoiGian: danhSachNhap[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSmallTextField("Tháng", "8")),
        const SizedBox(width: 10),
        Expanded(child: _buildSmallTextField("Năm", "2025")),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: const Text("Tìm", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => context.go("/quanly/nhaphang/them"),
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: const Text("Thêm mới", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 40,
            child: Text("STT", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              "Thời gian nhập",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              "Chức năng",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow({required String stt, required String thoiGian}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(stt, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(thoiGian, style: const TextStyle(fontSize: 14))),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildTextActionButton("Xem", Colors.blue, () {
                  showDialog(
                    context: context,
                    builder: (context) => NhaphangXem(phieuNhap: thoiGian),
                  );
                }),
                const VerticalDivider(width: 10),
                _buildTextActionButton("Xóa", Colors.red, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextActionButton(String label, Color color, VoidCallback onTap) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
