import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/nhanvien/logic/NhanVienLogic.dart';
import 'package:taphoa/features/admin/nhanvien/ui/nhanvien_sua.dart';

class NhanvienTong extends StatefulWidget {
  const NhanvienTong({super.key});

  @override
  State<NhanvienTong> createState() => _NhanvienTongState();
}

class _NhanvienTongState extends State<NhanvienTong> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NhanVienLogic>().fetchNhanVien();
    });
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<NhanVienLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Quản lý nhân viên",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () => logic.fetchNhanVien(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopActions(logic),
          Expanded(
            child: logic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : logic.listNhanVien.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: logic.listNhanVien.length,
                    itemBuilder: (context, index) => _buildEmployeeCard(
                      logic.listNhanVien[index],
                      index + 1,
                    ),
                  ),
          ),
          _buildPagination(logic),
        ],
      ),
    );
  }

  Widget _buildTopActions(NhanVienLogic logic) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm nhân viên...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  logic.searchNhanVien(_searchController.text);
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Tìm", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push("/quanly/nhanvien/them"),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Thêm nhân viên mới",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(dynamic nv, int stt) {

    bool isActived = nv.kichHoat;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo.shade50,
                child: Text(
                  stt.toString(),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nv.maNhanSu.hoTen,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "User: ${nv.tenDangNhap} • ${nv.maChucVu.tenChucVu}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActived ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActived ? "Hoạt động" : "Đang khoá",
                  style: TextStyle(
                    color: isActived ? Colors.green : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.edit_outlined, "Sửa", Colors.blue, () {
                showDialog(
                  context: context,
                  builder: (context) => NhanvienSua(nhanVienId: nv.id),
                );
              }),
              _buildActionButton(
                Icons.lock_reset_outlined,
                "Đổi mật khẩu",
                Colors.orange,
                () {
                  _showChangePasswordDialog(context, nv.id);
                },
              ),
              _buildActionButton(
                isActived ? Icons.lock_outline : Icons.lock_open,
                isActived ? "Khoá" : "Mở",
                isActived ? Colors.red : Colors.green,
                () async {

                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        isActived ? "Khóa tài khoản?" : "Mở khóa tài khoản?",
                      ),
                      content: Text(
                        "Bạn có chắc chắn muốn ${isActived ? 'khóa' : 'mở'} tài khoản này không?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Đồng ý"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final logic = context.read<NhanVienLogic>();

                    bool success = await logic.handleToggleStatus(nv.id);

                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${isActived ? 'Khóa' : 'Mở'} thành công!",
                          ),
                          backgroundColor: isActived
                              ? Colors.orange
                              : Colors.green,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(NhanVienLogic logic) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: logic.currentPage > 1
                ? () => logic.goToPage(logic.currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            "Trang ${logic.currentPage}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed:
                logic.listNhanVien.length ==
                    5
                ? () => logic.goToPage(logic.currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Không tìm thấy nhân viên nào",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, String nhanVienId) {
    final TextEditingController passController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Đổi mật khẩu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu mới",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Xác nhận mật khẩu",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val != passController.text ? "Mật khẩu không khớp" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("HỦY"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final logic = context.read<NhanVienLogic>();
                bool success = await logic.handleDoiMatKhau(
                  nhanVienId,
                  passController.text,
                );

                if (success && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Đổi mật khẩu thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text(
              "CẬP NHẬT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
