import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taphoa/features/admin/hanghoa/logic/hanghoa_logic.dart';
import 'package:taphoa/features/admin/hanghoa/ui/hanghoa_sua.dart';

class HanghoaTong extends StatefulWidget {
  const HanghoaTong({super.key});

  @override
  State<HanghoaTong> createState() => _HanghoaTongState();
}

class _HanghoaTongState extends State<HanghoaTong> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HangHoaLogic>().fetchHangHoa();
    });
  }

  String _formatCurrency(int value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<HangHoaLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Quản lý hàng hoá", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => logic.fetchHangHoa(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          _buildHeaderActions(logic),

          Expanded(
            child: logic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : logic.listHangHoa.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: () => logic.fetchHangHoa(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: logic.listHangHoa.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(logic.listHangHoa[index], index + 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Chưa có hàng hóa nào", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(HangHoaLogic logic) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Nhập tên hàng hoá...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    })
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final query = _searchController.text.trim();
                  context.read<HangHoaLogic>().searchHangHoa(query);
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Tìm", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push("/quanly/hanghoa/them"),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Thêm hàng hoá mới", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic item, int stt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo.shade50,
            child: Text(stt.toString(), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.ten, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("Giá: ", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(_formatCurrency(item.gia), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 12),
                    Text("Tồn: ", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(item.soLuong.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => HanghoaSua(data: item.toJson()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              minimumSize: const Size(60, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text("Sửa", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}