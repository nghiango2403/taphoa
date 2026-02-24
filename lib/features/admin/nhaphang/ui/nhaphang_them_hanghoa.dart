import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NhaphangThemHanghoa extends StatefulWidget {
  const NhaphangThemHanghoa({super.key});

  @override
  State<NhaphangThemHanghoa> createState() => _NhaphangThemHanghoaState();
}

class _NhaphangThemHanghoaState extends State<NhaphangThemHanghoa> {
  final List<Map<String, dynamic>> allProducts = [
    {'id': '1', 'name': 'Mì Hảo Hảo Tôm Chua Cay', 'giaban': 3500},
    {'id': '2', 'name': 'Nước ngọt Coca-Cola 330ml', 'giaban': 10000},
    {'id': '3', 'name': 'Sữa tươi Vinamilk không đường', 'giaban': 7000},
    {'id': '4', 'name': 'Bánh quy OREO', 'giaban': 15000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn hàng hóa"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm tên hàng hóa...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          final p = allProducts[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
            title: Text(p['name']),
            subtitle: Text("Giá bán: ${p['giaban']}đ"),
            onTap: () {
              context.pop(p);
            },
          );
        },
      ),
    );
  }
}
