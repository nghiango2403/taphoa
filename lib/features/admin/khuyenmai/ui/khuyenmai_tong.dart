import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taphoa/features/admin/khuyenmai/logic/khuyenmai_logic.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_tong_model.dart';
import 'package:taphoa/features/admin/khuyenmai/ui/khuyenmai_sua.dart';

class KhuyenmaiTong extends StatefulWidget {
  const KhuyenmaiTong({super.key});

  @override
  State<KhuyenmaiTong> createState() => _KhuyenmaiTongState();
}

class _KhuyenmaiTongState extends State<KhuyenmaiTong> {
  int _currentTrang = 1;
  final int _soLuongDong = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<KhuyenMaiLogic>().fetchKhuyenMai({
      "Trang": _currentTrang,
      "Dong": _soLuongDong,
    });
  }

  String _formatCurrency(int value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<KhuyenMaiLogic>();
    final listKM = logic.listKhuyenMai;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Quản lý khuyến mãi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Danh sách (${listKM.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.push("/quanly/khuyenmai/them"),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text("Thêm mới", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: logic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : listKM.isEmpty
                ? const Center(child: Text("Không có khuyến mãi nào"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listKM.length,
              itemBuilder: (context, index) {
                return _buildPromoCard(listKM[index], index);
              },
            ),
          ),

          _buildMobilePagination(logic),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Danhsach item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.shade50,
              child: Text(
                "${(index + 1) + (_currentTrang - 1) * _soLuongDong}",
                style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(item.tenKhuyenMai, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => KhuyenmaiSua(data: item.toJson()),
                );
              },
              child: const Text("Sửa", style: TextStyle(color: Colors.blue)),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildInfoItem("Bắt đầu", _formatDate(item.ngayBatDau), Icons.calendar_today_outlined),
                    _buildInfoItem("Kết thúc", _formatDate(item.ngayKetThuc), Icons.event_available_outlined),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoItem("Tiền KM", _formatCurrency(item.tienKhuyenMai), Icons.confirmation_number_outlined, color: Colors.red),
                    _buildInfoItem("Điều kiện", _formatCurrency(item.dieuKien), Icons.shopping_bag_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, {Color? color}) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePagination(KhuyenMaiLogic logic) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentTrang > 1 ? () {
              setState(() => _currentTrang--);
              _loadData();
            } : null,
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          Text(
            "Trang $_currentTrang / ${logic.tongSoTrang}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: _currentTrang < logic.tongSoTrang ? () {
              setState(() => _currentTrang++);
              _loadData();
            } : null,
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    );
  }
}