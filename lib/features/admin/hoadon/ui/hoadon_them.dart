import 'package:flutter/material.dart';

class HoaDonThem extends StatefulWidget {
  const HoaDonThem({super.key});

  @override
  State<HoaDonThem> createState() => _HoaDonThemState();
}

class _HoaDonThemState extends State<HoaDonThem> {
  List<Map<String, dynamic>> selectedItems = [];
  String _selectedKM = "Không áp dụng";
  String _selectedPayment = "Trực tiếp";

  void _showChonHangHoa() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const HoaDonThemChon(),
    );
    if (result != null) {
      setState(() => selectedItems.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền xám nhạt hiện đại
      appBar: AppBar(
        title: const Text(
          "Tạo hoá đơn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Thông tin thanh toán & KM
            _buildSectionTitle("Thông tin chung"),
            _buildPaymentInfoCard(),

            const SizedBox(height: 24),

            // Section 2: Danh sách hàng hóa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle("Danh sách sản phẩm"),
                TextButton.icon(
                  onPressed: _showChonHangHoa,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text("Thêm hàng"),
                  style: TextButton.styleFrom(foregroundColor: Colors.indigo),
                ),
              ],
            ),
            _buildProductListCard(),

            const SizedBox(height: 32),

            // Section 3: Nút hành động
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCustomDropdown(
              label: "Mã khuyến mãi",
              icon: Icons.confirmation_number_outlined,
              value: _selectedKM,
              items: ["Không áp dụng", "KM1 - 2000đ", "KM2 - 5%"],
              onChanged: (val) => setState(() => _selectedKM = val!),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            _buildCustomDropdown(
              label: "Hình thức thanh toán",
              icon: Icons.account_balance_wallet_outlined,
              value: _selectedPayment,
              items: ["Trực tiếp", "ZaloPay", "MoMo", "Chuyển khoản"],
              onChanged: (val) => setState(() => _selectedPayment = val!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: selectedItems.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedItems.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    item['ten'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Đơn giá: ${item['gia']} đ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: Colors.redAccent,
                    ),
                    onPressed: () =>
                        setState(() => selectedItems.removeAt(index)),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "Chưa có sản phẩm nào được chọn",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
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
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "HUỶ BỎ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "LƯU HOÁ ĐƠN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.indigo),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// Dialog chọn hàng hoá (Clean Version)
class HoaDonThemChon extends StatelessWidget {
  const HoaDonThemChon({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"ten": "Muối", "gia": 3000, "ton": 95},
      {"ten": "Kẹo", "gia": 5000, "ton": 1003},
      {"ten": "Áo Thun", "gia": 150000, "ton": 5},
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Chọn sản phẩm",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Tìm tên sản phẩm...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final i = items[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(
                        i['ten'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Kho: ${i['ton']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        "${i['gia']} đ",
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, i),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
