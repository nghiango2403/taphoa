import 'package:flutter/material.dart';
import 'package:taphoa/core/theme/app_colors.dart';
import 'package:taphoa/core/ultils/fomat_tien.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chọn hàng hóa")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Nhập tên hàng hóa",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.close),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    iconSize: 30,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                      itemHangHoa("Bánh mì", "20000", "100"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget itemHangHoa(String Ten, String Gia, String TonKho) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey),
    ),
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(bottom: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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

        ElevatedButton(
          onPressed: () {},
          child: Text("Chọn", style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(
              AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}
