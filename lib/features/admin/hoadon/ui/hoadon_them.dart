import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:taphoa/features/admin/hoadon/logic/hoadon_logic.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_xem_conhoatdong_model.dart';

class HoaDonThem extends StatefulWidget {
  const HoaDonThem({super.key});

  @override
  State<HoaDonThem> createState() => _HoaDonThemState();
}

class _HoaDonThemState extends State<HoaDonThem> {
  List<Map<String, dynamic>> selectedItems = [];
  List<Danhsach> danhSach = [];
  Danhsach? _selectedKM;
  String _selectedPayment = "Trực tiếp";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HoaDonLogic>().layDsKhuyenMaiConHoatDong();
    });
  }

  void _showChonHangHoa() async {
    final dynamic result = await context.push('/quanly/nhaphang/them/hanghoa');
    if (result != null && mounted) {
      setState(() {
        int index = selectedItems.indexWhere(
          (item) => item['MaHangHoa'] == result.id,
        );

        if (index != -1) {
          selectedItems[index]['SoLuong'] += 1;
        } else {
          selectedItems.add({
            'MaHangHoa': result.id,
            'name': result.ten,
            'SoLuong': 1,
            'Gia': result.gia,
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
      body: Consumer<HoaDonLogic>(
        builder: (context, logic, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Thông tin chung"),
                _buildPaymentInfoCard(logic),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("Danh sách sản phẩm"),
                    TextButton.icon(
                      onPressed: _showChonHangHoa,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text("Thêm hàng"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                _buildProductListCard(),
                const SizedBox(height: 32),
                _buildActionButtons(logic), // Truyền logic vào đây
              ],
            ),
          );
        },
      ),
    );
  }

  // --- TỐI ƯU NÚT BẤM VÀ LOGIC ---
  Widget _buildActionButtons(HoaDonLogic logic) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: logic.isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
            onPressed: (selectedItems.isEmpty || logic.isLoading)
                ? null
                : () async {
                    Map<String, dynamic> data = {
                      "MaKhuyenMai": _selectedKM,
                      "HinhThucThanhToan": _selectedPayment,
                      "ChiTietHD": selectedItems,
                    };

                    bool success = await logic.ThemHoaDon(data);

                    if (!mounted) return;

                    if (success) {
                      if (logic.qrUrl != null) {
                        // HIỆN QR VÀ SAU ĐÓ POP
                        _showQrPaymentModal(context, logic.qrUrl!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thêm hóa đơn thành công!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.pop(true);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(logic.errorMessage ?? "Có lỗi xảy ra"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: logic.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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

  // --- HIỂN THỊ MODAL QR CHUYÊN NGHIỆP ---
  void _showQrPaymentModal(BuildContext context, String qrData) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      // Không cho bấm ra ngoài tắt (ép xác nhận)
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Chặn nút back android
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thanh toán",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Render mã QR
                QrImageView(
                  data: qrData,
                  size: 220.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Quét mã để hoàn tất đơn hàng",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[700],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Đóng Modal
                      GoRouter.of(this.context).pop(
                        true,
                      ); // Thoát màn hình Thêm (Lưu ý dùng context của State)
                    },
                    child: const Text(
                      "XÁC NHẬN ĐÃ QUÉT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
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

  Widget _buildPaymentInfoCard(HoaDonLogic logic) {
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
            // Dropdown cho Khuyến mãi
            _buildCustomDropdown<Danhsach>(
              label: "Mã khuyến mãi",
              icon: Icons.confirmation_number_outlined,
              value: _selectedKM,
              items: logic.listKhuyenMai,
              hint: logic.kmIsLoading ? "Đang tải..." : "Chọn mã (nếu có)",
              itemAsString: (item) =>
                  "${item.tenKhuyenMai} (-${item.tienKhuyenMai}đ)(>${item.dieuKien}đ)",
              onChanged: (val) => setState(() => _selectedKM = val),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            // Dropdown cho Thanh toán (Dùng String trực tiếp)
            _buildCustomDropdown<String>(
              label: "Hình thức thanh toán",
              icon: Icons.account_balance_wallet_outlined,
              value: _selectedPayment,
              items: ["Trực tiếp", "ZaloPay", "MoMo"],
              itemAsString: (item) => item,
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
                // Tính thành tiền cho từng item
                final double thanhTien =
                    (item['Gia'] ?? 0) * (item['SoLuong'] ?? 1);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "Đơn giá: ${item['Gia']} đ",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Thành tiền: ${thanhTien.toStringAsFixed(0)} đ",
                        style: const TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bộ tăng giảm số lượng
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _buildQtyBtn(Icons.remove, () {
                              if (item['SoLuong'] > 1) {
                                setState(() => item['SoLuong']--);
                              } else {
                                // Nếu giảm xuống 0 thì hỏi xóa hoặc xóa luôn
                                setState(() => selectedItems.removeAt(index));
                              }
                            }),
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                initialValue: item['SoLuong'].toString(),
                                key: ValueKey(
                                  "qty_${item['MaHangHoa']}_${item['SoLuong']}",
                                ),
                                // Quan trọng để cập nhật UI
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onFieldSubmitted: (value) {
                                  int? newVal = int.tryParse(value);
                                  if (newVal != null && newVal > 0) {
                                    setState(() => item['SoLuong'] = newVal);
                                  } else {
                                    setState(
                                      () => item['SoLuong'] = 1,
                                    ); // Reset nếu nhập lỗi
                                  }
                                },
                              ),
                            ),
                            _buildQtyBtn(Icons.add, () {
                              setState(() => item['SoLuong']++);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Nút xóa nhanh
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => selectedItems.removeAt(index)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 18, color: Colors.indigo),
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

  Widget _buildCustomDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemAsString,
    required ValueChanged<T?> onChanged,
    String hint = "Chọn dữ liệu",
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemAsString(item),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

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
