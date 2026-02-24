import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NhaphangThem extends StatefulWidget {
  const NhaphangThem({super.key});

  @override
  State<NhaphangThem> createState() => _NhaphangThemState();
}

class _NhaphangThemState extends State<NhaphangThem> {
  List<Map<String, dynamic>> selectedItems = [];
  double get totalAmount {
    return selectedItems.fold(
      0,
      (sum, item) => sum + (item['soluong'] * item['gianhap']),
    );
  }

  Future<void> _navigateToSearch() async {
    final result = await context.push<Map<String, dynamic>>(
      '/quanly/nhaphang/them/hanghoa',
    );

    if (result != null && mounted) {
      setState(() {
        int index = selectedItems.indexWhere(
          (item) => item['id'] == result['id'],
        );
        if (index != -1) {
          selectedItems[index]['soluong'] += 1;
        } else {
          selectedItems.add({
            'id': result['id'],
            'name': result['name'],
            'giaban': result['giaban'],
            'soluong': 1,
            'gianhap': result['giaban'],
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Tạo phiếu nhập",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildAddHeader(),

          Expanded(
            child: selectedItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) => _buildProductCard(index),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: selectedItems.isNotEmpty
          ? SafeArea(child: _buildBottomBar())
          : null,
    );
  }

  Widget _buildAddHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: _navigateToSearch,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.shade300),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, color: Colors.indigo),
              SizedBox(width: 8),
              Text(
                "Bấm để tìm và chọn hàng hóa",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final item = selectedItems[index];
    double thanhTien = item['soluong'] * item['gianhap'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Giá bán: ${item['giaban']}đ"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => setState(() => selectedItems.removeAt(index)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildInput(
                    "Số lượng",
                    item['soluong'].toString(),
                    (val) => setState(
                      () => item['soluong'] = double.tryParse(val) ?? 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInput(
                    "Giá nhập",
                    item['gianhap'].toString(),
                    (val) => setState(
                      () => item['gianhap'] = double.tryParse(val) ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Thành tiền:", style: TextStyle(fontSize: 12)),
                Text(
                  "${thanhTien.toStringAsFixed(0)}đ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    String initialValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: initialValue,
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổng tiền phiếu nhập:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "${totalAmount.toStringAsFixed(0)}đ",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Hủy",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    /* Logic lưu vào DB */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B894),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Lưu phiếu",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Chưa có hàng hóa nào được chọn",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
