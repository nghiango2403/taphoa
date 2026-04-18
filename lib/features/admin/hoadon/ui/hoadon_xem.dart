import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/hoadon/logic/hoadon_logic.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_model.dart';

class HoaDonXem extends StatefulWidget {
  final Item item;

  const HoaDonXem({super.key, required this.item});

  @override
  State<HoaDonXem> createState() => _HoaDonXemState();
}

class _HoaDonXemState extends State<HoaDonXem> {
  int tongTien = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchdata();
    });
  }

  void _fetchdata() {
    context.read<HoaDonLogic>().layChiTietHoaDon(maHoaDon: widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Consumer<HoaDonLogic>(
          builder: (context, logic, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  "Hình thức thanh toán:",
                  "${widget.item.hinhThucThanhToan}",
                ),
                if (widget.item.hinhThucThanhToan != "Trực tiếp")
                  _buildInfoRow(
                    "Trạng thái thanh toán:",
                    "${logic.trangThaiThanhToan}",
                  ),
                _buildInfoRow(
                  "Khuyến mãi:",
                  logic.infokhuyenmai != null
                      ? "${logic.infokhuyenmai!.tenKhuyenMai} (-${logic.infokhuyenmai!.tienKhuyenMai}đ) (>${logic.infokhuyenmai!.dieuKien}đ)"
                      : "Không áp dụng khuyến mãi",
                ),
                const SizedBox(height: 15),

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
                      children: [
                        _Cell(text: "Tên hàng", isHeader: true),
                        _Cell(text: "Giá (đ)", isHeader: true),
                        _Cell(text: "Tổng", isHeader: true),
                      ],
                    ),
                    ...(logic.info.map((item) {
                      final thanhTien = item.soLuong * item.donGia;
                      tongTien += thanhTien;

                      return TableRow(
                        children: [
                          // Truy cập thông qua object item (Datum) -> maHangHoa (MaHangHoa) -> ten
                          _Cell(text: item.maHangHoa.ten),
                          _Cell(text: "${item.donGia}"),
                          _Cell(text: "$thanhTien"),
                        ],
                      );
                    })).toList(),
                    // Đừng quên .toList() ở cuối nếu dùng spread operator (...)
                  ],
                ),

                const SizedBox(height: 20),

                const Divider(height: 30),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Tổng cộng: ${tongTien} đ",
                    style: const TextStyle(
                      color: Color(0xFF00C853),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          },
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
