import 'package:flutter/material.dart';

class HoadonXem extends StatelessWidget {
  final Map<String, dynamic> data; // Nhận dữ liệu hoá đơn truyền vào

  const HoadonXem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Chúng ta trả về AlertDialog trực tiếp ở đây
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Chi tiết hoá đơn",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
      content: SingleChildScrollView(
        // Thêm Scroll để tránh tràn màn hình khi hoá đơn dài
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              "Hình thức thanh toán:",
              "${data['hinhThuc'] ?? 'Trực tiếp'}",
            ),
            _buildInfoRow("Khuyến mãi:", "${data['km'] ?? 'Không áp dụng'}"),
            const SizedBox(height: 15),

            // Bảng chi tiết hàng hoá
            Table(
              border: TableBorder.all(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  // backgroundColor: Color(0xFFF8F9FA),
                  children: [
                    _Cell(text: "Tên hàng", isHeader: true),
                    _Cell(text: "Giá (đ)", isHeader: true),
                    _Cell(text: "Tổng", isHeader: true),
                  ],
                ),
                // Map dữ liệu từ danh sách hàng hoá vào bảng
                ...((data['items'] as List? ?? []).map(
                  (item) => TableRow(
                    children: [
                      _Cell(text: "${item['ten']}"),
                      _Cell(text: "${item['gia']}"),
                      _Cell(text: "${item['thanhTien']}"),
                    ],
                  ),
                )),
              ],
            ),

            const SizedBox(height: 20),

            // Trạng thái thanh toán
            Row(
              children: [
                const Text("Trạng thái: ", style: TextStyle(fontSize: 14)),
                Text(
                  "${data['trangThai'] ?? 'Thành công'}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            // Tổng cộng
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tổng cộng: ${data['tongTien'] ?? '0'} đ",
                style: const TextStyle(
                  color: Color(0xFF00C853), // Màu xanh lá chuẩn
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Đóng", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

// Widget phụ trợ cho Cell của Table
class _Cell extends StatelessWidget {
  final String text;
  final bool isHeader;
  const _Cell({required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
