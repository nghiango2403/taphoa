import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/nhaphang/logic/nhaphang_logic.dart';
import 'package:taphoa/features/admin/nhaphang/ui/nhaphang_xem.dart';

class NhaphangTong extends StatefulWidget {
  const NhaphangTong({super.key});

  @override
  State<NhaphangTong> createState() => _NhaphangTongState();
}

class _NhaphangTongState extends State<NhaphangTong> {

  final TextEditingController _thangController = TextEditingController(
    text: DateTime.now().month.toString(),
  );
  final TextEditingController _namController = TextEditingController(
    text: DateTime.now().year.toString(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onSearch(page: 1));
  }

  void _onSearch({int page = 1}) {
    context.read<NhapHangLogic>().fetchPhieuNhap(
      trang: page,
      thang: int.tryParse(_thangController.text) ?? DateTime.now().month,
      nam: int.tryParse(_namController.text) ?? DateTime.now().year,
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text(
          "Bạn có chắc chắn muốn xóa phiếu nhập này không? Hành động này không thể hoàn tác.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final logic = context.read<NhapHangLogic>();
              bool success = await logic.handleXoaPhieu(id);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa phiếu nhập thành công")),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(logic.errorMessage ?? "Lỗi xóa phiếu"),
                  ),
                );
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<NhapHangLogic>();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderActions(),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _buildTableHeader(),
                    const Divider(height: 1),
                    Expanded(
                      child: logic.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemCount: logic.listPhieu.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = logic.listPhieu[index];
                                return _buildTableRow(
                                  stt:
                                      (index + 1 + (logic.currentPage - 1) * 10)
                                          .toString(),
                                  thoiGian: DateFormat(
                                    'HH:mm:ss dd/MM/yyyy',
                                  ).format(item.thoiGianNhap.toLocal()),
                                  id: item.id,
                                );
                              },
                            ),
                    ),

                    _buildPaginationBar(logic),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar(NhapHangLogic logic) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: logic.currentPage > 1
                ? () => _onSearch(page: logic.currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            "Trang ${logic.currentPage} / ${logic.totalPage}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: logic.currentPage < logic.totalPage
                ? () => _onSearch(page: logic.currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        Expanded(child: _buildSmallTextField("Tháng", _thangController)),
        const SizedBox(width: 10),
        Expanded(child: _buildSmallTextField("Năm", _namController)),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onSearch(page: 1),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Tìm", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => {context.push("/quanly/nhaphang/them")},

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Thêm", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSmallTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
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

  Widget _buildTableRow({
    required String stt,
    required String thoiGian,
    required String id,
  }) {
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
                    builder: (context) => NhaphangXem(phieuId: id),
                  );
                }),
                const VerticalDivider(width: 10),
                _buildTextActionButton("Xóa", Colors.red, () {
                  _confirmDelete(context, id);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextActionButton(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
