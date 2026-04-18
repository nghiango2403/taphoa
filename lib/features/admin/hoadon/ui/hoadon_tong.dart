import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/hoadon/logic/hoadon_logic.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_model.dart';
import 'package:taphoa/features/admin/hoadon/ui/hoadon_xem.dart';

class HoaDonTong extends StatefulWidget {
  const HoaDonTong({super.key});

  @override
  State<HoaDonTong> createState() => _HoaDonTongState();
}

class _HoaDonTongState extends State<HoaDonTong> {
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _monthController.text = DateTime.now().month.toString();
    _yearController.text = DateTime.now().year.toString();
    // Gọi API lấy danh sách ngay khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetcitemata();
    });
  }

  void _fetcitemata() {
    final String fullLocation = GoRouterState.of(context).uri.toString();
    if (fullLocation == "/quanly/hoadon") {
      context.read<HoaDonLogic>().layDanhSachHoaDon(
        page: 1,
        thang: _monthController.text,
        nam: _yearController.text,
      );
    } else {
      context.read<HoaDonLogic>().layDanhSachHoaDonNhanVien(
        page: 1,
        thang: _monthController.text,
        nam: _yearController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
      body: Consumer<HoaDonLogic>(
        builder: (context, logic, child) {
          return Column(
            children: [
              _buildFilterHeader(logic),
              Expanded(
                child: logic.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : logic.listHoaDon.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async => _fetcitemata(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: logic.listHoaDon.length,
                          itemBuilder: (context, index) {
                            return _buildHoaDonItem(
                              logic.listHoaDon[index],
                              logic,
                            );
                          },
                        ),
                      ),
              ),
              _buildPagination(logic),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHoaDonItem(Item item, HoaDonLogic logic) {
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
                "Hóa đơn #${item.id.substring(item.id.length - 4)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              _buildPaymentChip(item.hinhThucThanhToan),
            ],
          ),
          const Divider(height: 24),
          if (item.maNhanVien.hoTen != "N/A")
            _rowDetail(
              Icons.person_outline,
              "Nhân viên: ",
              item.maNhanVien.hoTen,
              isBlue: true,
            ),
          _rowDetail(
            Icons.calendar_today_outlined,
            "Ngày lập: ",
            item.ngayLap.toString(),
          ),
          _rowDetail(
            Icons.confirmation_number_outlined,
            "Khuyến mãi: ",
            item.maKhuyenMai ?? "Không có",
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => _openDetailDialog(item),
                icon: const Icon(Icons.visibility_outlined, size: 20),
                label: const Text("Chi tiết"),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      bool kq = await logic.xoaHoaDon(item.id);
                      if (kq) {
                        // 2. Kiểm tra xem Widget còn "sống" trong cây thư mục không trước khi dùng BuildContext
                        if (!context.mounted) return;

                        // 3. Thông báo thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa hóa đơn thành công!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        _fetcitemata();
                      } else {
                        // Xử lý khi xóa thất bại
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              logic.errorMessage ?? 'Có lỗi xảy ra',
                            ),
                          ),
                        );
                      }
                    },
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

  Widget _buildFilterHeader(HoaDonLogic logic) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _monthController,
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
              controller: _yearController,
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
            onPressed: _fetcitemata,
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
              bool isSuccess = context.push("/quanly/hoadon/them") as bool;
              if (isSuccess) {
                _fetcitemata();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
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

  Widget _buildPagination(HoaDonLogic logic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: logic.currentPage > 1
              ? () => logic.layDanhSachHoaDon(page: logic.currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        // Hiển thị số trang
        Text("${logic.currentPage} / ${logic.totalPages}"),
        IconButton(
          onPressed: logic.currentPage < logic.totalPages
              ? () => logic.layDanhSachHoaDon(page: logic.currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  void _openDetailDialog(Item data) {
    showDialog(
      context: context,
      builder: (context) => HoaDonXem(item: data),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        // Tránh lỗi tràn khung khi màn hình nhỏ
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hình ảnh minh họa hoặc Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Colors.indigo.shade200,
              ),
            ),
            const SizedBox(height: 24),

            // Tiêu đề chính
            const Text(
              "Không có hóa đơn nào",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Mô tả chi tiết (Dynamic dựa trên bộ lọc nếu muốn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Danh sách hiện đang trống. Hãy thử thay đổi bộ lọc hoặc tạo hóa đơn mới nhé!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Nút hành động nhanh (Tùy chọn)
            OutlinedButton.icon(
              onPressed: () {
                // Gọi lại hàm fetch data để làm mới
                context.read<HoaDonLogic>().layDanhSachHoaDon();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Tải lại dữ liệu"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                side: BorderSide(color: Colors.indigo.shade100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
