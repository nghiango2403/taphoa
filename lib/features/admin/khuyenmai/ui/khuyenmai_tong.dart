import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/admin/khuyenmai/ui/khuyenmai_sua.dart';

class KhuyenmaiTong extends StatefulWidget {
  const KhuyenmaiTong({super.key});

  @override
  State<KhuyenmaiTong> createState() => _KhuyenmaiTongState();
}

class _KhuyenmaiTongState extends State<KhuyenmaiTong> {
  final List<Map<String, dynamic>> dsKhuyenMai = [
    {
      "stt": "1",
      "ten": "Khuyến mãi mùa hè",
      "batDau": "1/8/2025",
      "ketThuc": "31/8/2025",
      "tien": "10.000 đ",
      "dieuKien": "100.000 đ",
    },
    {
      "stt": "2",
      "ten": "KM3",
      "batDau": "17/8/2025",
      "ketThuc": "31/8/2025",
      "tien": "1.000 đ",
      "dieuKien": "10.000 đ",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Quản lý khuyến mãi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                  "Danh sách (${dsKhuyenMai.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.push("/quanly/khuyenmai/them");
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text(
                    "Thêm mới",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dsKhuyenMai.length,
              itemBuilder: (context, index) {
                return _buildPromoCard(dsKhuyenMai[index]);
              },
            ),
          ),

          _buildMobilePagination(),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.shade50,
              child: Text(
                item['stt'],
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              item['ten'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return KhuyenmaiSua(data: item);
                  },
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
                    _buildInfoItem(
                      "Bắt đầu",
                      item['batDau'],
                      Icons.calendar_today_outlined,
                    ),
                    _buildInfoItem(
                      "Kết thúc",
                      item['ketThuc'],
                      Icons.event_available_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoItem(
                      "Tiền KM",
                      item['tien'],
                      Icons.confirmation_number_outlined,
                      color: Colors.red,
                    ),
                    _buildInfoItem(
                      "Điều kiện",
                      item['dieuKien'],
                      Icons.shopping_bag_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePagination() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          const Text(
            "Trang 1 / 10",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    );
  }
}
