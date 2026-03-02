import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/nhaphang/logic/nhaphang_logic.dart';

class NhaphangXem extends StatefulWidget {
  final String phieuId;
  const NhaphangXem({super.key, required this.phieuId});

  @override
  State<NhaphangXem> createState() => _NhaphangXemState();
}

class _NhaphangXemState extends State<NhaphangXem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NhapHangLogic>().fetchChiTietPhieu(widget.phieuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###", "vi_VN");

    return AlertDialog(
      title: const Text(
        "Chi tiết phiếu nhập",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Consumer<NhapHangLogic>(
        builder: (context, logic, child) {
          if (logic.isLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (logic.listChiTiet.isEmpty) {
            return const Text("Không có dữ liệu mặt hàng.");
          }

          return SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: IntrinsicColumnWidth(),
                  2: FlexColumnWidth(2),
                },
                children: [
                  _buildHeaderRow(),
                  ...logic.listChiTiet.map(
                    (item) => TableRow(
                      children: [
                        _buildCell(item.maHangHoa.ten),
                        _buildCell(item.soLuong.toString(), center: true),
                        _buildCell(
                          currencyFormat.format(item.tienHang),
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Đóng"),
        ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        _buildCell("Tên hàng", bold: true),
        _buildCell("SL", bold: true, center: true),
        _buildCell("Thành tiền", bold: true),
      ],
    );
  }

  Widget _buildCell(String text, {bool bold = false, bool center = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}
