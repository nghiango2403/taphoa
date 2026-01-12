import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/core/ultils/fomat_tien.dart';

class BillAdd extends StatefulWidget {
  const BillAdd({super.key});

  @override
  State<BillAdd> createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Text(
              "Thêm hóa đơn",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownMenu(
              width: double.infinity,
              hintText: "Chọn mã khuyến mãi",
              label: Text("Mã khuyến mãi"),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "1", label: "a"),
                DropdownMenuEntry(value: "2", label: "b"),
              ],
            ),
            SizedBox(height: 16),
            DropdownMenu(
              width: double.infinity,
              label: Text("Hình thức thanh toán"),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "1", label: "a"),
                DropdownMenuEntry(value: "2", label: "b"),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Thêm hàng hóa"),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.go("/product_add");
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      AppColors.primaryColor,
                    ),
                    shape: WidgetStatePropertyAll(CircleBorder()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                      itemhanghoa("Bánh mì", "20000", "100"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Hủy", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Lưu", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget itemhanghoa(String Ten, String Gia, String TonKho) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(bottom: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tên hàng hóa: $Ten"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Giá: ${FomatTien.format(int.parse(Gia))}đ"),
                  SizedBox(width: 16),
                  Text("Tồn kho: $TonKho"),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => print("a"),
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ],
    ),
  );
}
