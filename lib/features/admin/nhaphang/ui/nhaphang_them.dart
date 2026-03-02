import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../logic/nhaphang_logic.dart';

class NhaphangThem extends StatefulWidget {
  const NhaphangThem({super.key});

  @override
  State<NhaphangThem> createState() => _NhaphangThemState();
}

class _NhaphangThemState extends State<NhaphangThem> {

  final Map<String, TextEditingController> _qtyControllers = {};
  final Map<String, TextEditingController> _priceControllers = {};

  List<Map<String, dynamic>> selectedItems = [];

  double get totalAmount {
    return selectedItems.fold(
      0,
      (sum, item) => sum + (item['soluong'] * item['gianhap']),
    );
  }

  Future<void> _navigateToSearch() async {

    final dynamic result = await context.push('/quanly/nhaphang/them/hanghoa');

    if (result != null && mounted) {
      setState(() {
        int index = selectedItems.indexWhere((item) => item['id'] == result.id);

        if (index != -1) {
          selectedItems[index]['soluong'] += 1;
          _qtyControllers[result.id]?.text = selectedItems[index]['soluong']
              .toString();
        } else {

          _qtyControllers[result.id] = TextEditingController(text: "1");
          _priceControllers[result.id] = TextEditingController(text: '0');

          selectedItems.add({
            'id': result.id,
            'name': result.ten,
            'giaban': result.gia,
            'soluong': 1.0,
            'gianhap': 0,
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var c in _qtyControllers.values) {
      c.dispose();
    }
    for (var c in _priceControllers.values) {
      c.dispose();
    }
    super.dispose();
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
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
      bottomNavigationBar: selectedItems.isNotEmpty ? _buildBottomBar() : null,
    );
  }

  Widget _buildAddHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: _navigateToSearch,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.shade200, width: 1.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.indigo),
              SizedBox(width: 8),
              Text(
                "Thêm hàng hóa vào phiếu",
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
    final String id = item['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Giá niêm yết: ${NumberFormat("#,###").format(item['giaban'])}đ",
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.redAccent,
              ),
              onPressed: () => setState(() {
                _qtyControllers.remove(id);
                _priceControllers.remove(id);
                selectedItems.removeAt(index);
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildInput("Số lượng", _qtyControllers[id]!, (val) {
                    setState(() => item['soluong'] = double.tryParse(val) ?? 0);
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInput(
                    "Tổng giá nhập (đ)",
                    _priceControllers[id]!,
                    (val) {
                      setState(
                        () => item['gianhap'] = double.tryParse(val) ?? 0,
                      );
                    },
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
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TỔNG TIỀN PHIẾU:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "${NumberFormat("#,###").format(totalAmount)}đ",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

                  if (selectedItems.isEmpty) return;

                  final logic = context.read<NhapHangLogic>();
                  bool success = await logic.handleThemPhieuNhap(selectedItems);

                  if (success && mounted) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lưu phiếu nhập thành công!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    context.pop(true);
                  } else if (mounted) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(logic.errorMessage ?? "Có lỗi xảy ra"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B894),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: context.watch<NhapHangLogic>().isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "XÁC NHẬN LƯU PHIẾU",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "Phiếu nhập chưa có hàng hóa nào",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
