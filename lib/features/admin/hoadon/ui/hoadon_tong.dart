import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/admin/hoadon/ui/hoadon_xem.dart';
// Giả sử các file này nằm trong project của bạn
// import 'package:taphoa/features/admin/hoadon/ui/hoadon_them.dart';
// import 'package:taphoa/features/admin/hoadon/ui/hoadon_xem.dart';

class HoaDonTong extends StatefulWidget {
  const HoaDonTong({super.key});

  @override
  State<HoaDonTong> createState() => _HoaDonTongState();
}

class _HoaDonTongState extends State<HoaDonTong> {
  final List<Map<String, dynamic>> _hoaDons = [
    {
      "stt": 1,
      "nhanVien": "Nguyễn Văn Minh",
      "ngay": "10:32:00 22/8/2025",
      "km": "6882...46de",
      "hinhThuc": "ZaloPay",
      "tongTien": "18.000",
    },
    {
      "stt": 2,
      "nhanVien": "Nguyễn Văn Minh",
      "ngay": "18:28:44 20/8/2025",
      "km": "6882...46e2",
      "hinhThuc": "Trực tiếp",
      "tongTien": "50.000",
    },
    {
      "stt": 5,
      "nhanVien": "test",
      "ngay": "15:37:16 1/8/2025",
      "km": "",
      "hinhThuc": "MoMo",
      "tongTien": "120.000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Màu nền nhẹ cho UI hiện đại
      appBar: AppBar(
        title: const Text(
          "Quản lý hoá đơn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildFilterHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _hoaDons.length,
              itemBuilder: (context, index) {
                return _buildHoaDonItem(_hoaDons[index]);
              },
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  // --- WIDGET ITEM HÓA ĐƠN (CARD) ---
  Widget _buildHoaDonItem(Map<String, dynamic> hd) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hóa đơn #${hd['stt']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              _buildPaymentChip(hd['hinhThuc']),
            ],
          ),
          const Divider(height: 24),
          _rowDetail(
            Icons.person_outline,
            "Nhân viên: ",
            hd['nhanVien'],
            isBlue: true,
          ),
          _rowDetail(Icons.calendar_today_outlined, "Ngày lập: ", hd['ngay']),
          _rowDetail(Icons.wallet_outlined, "Thanh toán: ", hd['hinhThuc']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => _openDetailDialog(hd),
                icon: const Icon(Icons.visibility_outlined, size: 20),
                label: const Text("Chi tiết"),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              Row(
                children: [
                  Text(
                    "${hd['tongTien']} đ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CÁC THÀNH PHẦN PHỤ TRỢ ---

  Widget _rowDetail(
    IconData icon,
    String label,
    String value, {
    bool isBlue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isBlue ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Tháng",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Năm",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Tìm", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {
              context.push("/quanly/hoadon/them");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Màu nền xanh lá
              foregroundColor: Colors.white, // Màu chữ và icon
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            label: const Text(
              "Thêm",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "1",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  void _openDetailDialog(Map<String, dynamic> hd) {
    // Gọi màn hình HoadonXem của bạn
    showDialog(
      context: context,
      builder: (context) => HoadonXem(data: {...hd}),
    );
  }
}
