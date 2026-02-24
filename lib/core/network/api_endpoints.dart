import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static final String baseUrl =
      dotenv.env['LINK_BACKEND'] ?? 'http://localhost:8080/';

  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration connectionTimeout = Duration(seconds: 15);

  static const String login = "/dangnhap";
  static const String laythongtintaikhoan = "/laythongtintaikhoan";
  static const String refreshToken = "/auth/refresh-token";
  static const String forgotPassword = "/auth/forgot-password";

  static const String getStaffList = "/staff/all";
  static const String addStaff = "/staff/create";
  // static const String updateStaff = (int id) => "/staff/update/$id"; // Endpoint dạng function cho ID
}
