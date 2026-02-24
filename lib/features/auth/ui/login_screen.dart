import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/core/theme/app_colors.dart';

import '../logic/auth_logic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Sử dụng controller để lấy dữ liệu nhập vào
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe AuthLogic
    final authLogic = context.watch<AuthLogic>();

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tạp hóa",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 60),

              // Tên đăng nhập
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Tên đăng nhập",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: authLogic.isObscured, // Lấy từ Logic
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        authLogic.toggleObscure(), // Gọi hàm từ Logic
                    icon: Icon(
                      authLogic.isObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              // Hiển thị lỗi nếu có
              if (authLogic.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    authLogic.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 30),

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authLogic.isLoading
                      ? null
                      : () async {
                          await authLogic.login(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          // Sau khi xong, kiểm tra nếu có user thì log ra thông tin
                          if (authLogic.user != null) {
                            final user = authLogic.user!.data.thongTin;
                            print("--- ĐĂNG NHẬP THÀNH CÔNG ---");
                            print("Họ tên: ${user.hoTen}");
                            print("Chức vụ: ${user.chucVu}");
                            print(
                              "Access Token: ${authLogic.user!.data.accessToken}",
                            );

                            // Hiển thị thông báo nhanh
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Chào mừng ${user.hoTen}!"),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: authLogic.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(color: Colors.white),
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
