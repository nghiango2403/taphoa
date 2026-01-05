import 'package:flutter/material.dart';

class ProductGet extends StatefulWidget {
  const ProductGet({super.key});

  @override
  State<ProductGet> createState() => _ProductGetState();
}

class _ProductGetState extends State<ProductGet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text("Đây là trang Sản phẩm")));
  }
}
