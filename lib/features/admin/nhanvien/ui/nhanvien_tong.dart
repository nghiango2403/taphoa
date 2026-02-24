import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/features/admin/nhanvien/ui/nhanvien_sua.dart';

class NhanvienTong extends StatefulWidget {
  const NhanvienTong({super.key});

  @override
  State<NhanvienTong> createState() => _NhanvienTongState();
}

class _NhanvienTongState extends State<NhanvienTong> {
  final List<Map<String, dynamic>> dsNhanVien = [
    {
      "stt": 1,
      "name": "Nguyễn Văn Minh",
      "user": "TK00001",
      "role": "Quản lý",
      "isLocked": true,
    },
    {
      "stt": 2,
      "name": "test",
      "user": "TK00002",
      "role": "Nhân viên",
      "isLocked": true,
    },
    {
      "stt": 3,
      "name": "Nguyễn Văn A",
      "user": "TK00003",
      "role": "Nhân viên",
      "isLocked": false,
    },
    {
      "stt": 4,
      "name": "Ngô Hữu Nghĩa",
      "user": "TK00004",
      "role": "Nhân viên",
      "isLocked": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: Column(
        children: [
          _buildTopActions(),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dsNhanVien.length,
              itemBuilder: (context, index) =>
                  _buildEmployeeCard(dsNhanVien[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
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
                onPressed: () {},
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
              onPressed: () {
                context.push("/quanly/nhanvien/them");
              },
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

  Widget _buildEmployeeCard(Map<String, dynamic> nv) {
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
                  nv['stt'].toString(),
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
                      nv['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "ID: ${nv['user']} • ${nv['role']}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: nv['isLocked']
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  nv['isLocked'] ? "Đang khoá" : "Hoạt động",
                  style: TextStyle(
                    color: nv['isLocked'] ? Colors.red : Colors.green,
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
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return NhanvienSua(data: nv);
                  },
                );
              }),
              _buildActionButton(
                Icons.lock_reset_outlined,
                "Đổi mã",
                Colors.orange,
                () {},
              ),
              _buildActionButton(
                nv['isLocked'] ? Icons.lock_open : Icons.lock_outline,
                nv['isLocked'] ? "Mở" : "Khoá",
                nv['isLocked'] ? Colors.green : Colors.red,
                () {},
              ),
            ],
          ),
        ],
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
}
