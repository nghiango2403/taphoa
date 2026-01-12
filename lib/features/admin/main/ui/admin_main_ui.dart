import 'package:flutter/material.dart';

class AdminMainUi extends StatefulWidget {
  const AdminMainUi({super.key});

  @override
  State<AdminMainUi> createState() => _AdminMainUiState();
}

class _AdminMainUiState extends State<AdminMainUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Chọn chức năng"))),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: item(
                  Icons.move_to_inbox,
                  "Nhập hàng",
                  Colors.blue.shade900,
                  Colors.white,
                ),
              ),
              Expanded(
                child: item(
                  Icons.trending_up,
                  "Thống kê",
                  Color(0xFFCBFBF1),
                  Color(0xFF39938A),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: [
              Expanded(
                child: item(
                  Icons.receipt_long,
                  "Hóa đơn",
                  Color(0xFF9C27B0),
                  Colors.white,
                ),
              ),
              Expanded(
                child: item(
                  Icons.local_offer,
                  "Khuyến mãi",
                  Color(0xFFFB8C00),
                  Colors.white,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),

          Row(
            children: [
              Expanded(
                child: item(
                  Icons.person,
                  "Nhân viên",
                  Color(0xFF546E7A),
                  Colors.white,
                ),
              ),
              Expanded(
                child: item(
                  Icons.shopping_bag_outlined,
                  "Hàng hóa",
                  Colors.red,
                  Colors.white,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ],
      ),
    );
  }
}

Widget item(IconData icon, String title, Color color, Color iconColor) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          spreadRadius: 2,
          blurRadius: 7,
          color: Colors.black,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.all(32),
    margin: const EdgeInsets.all(16),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Icon(icon, size: 30, color: iconColor),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 8),
        Text(
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
