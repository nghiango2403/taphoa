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
  static const String doithongtintaikhoan = "/doithongtintaikhoan";

  static const String laykhuyenmai = "/laykhuyenmai";
  static const String themkhuyenmai = "/themkhuyenmai";
  static const String capnhatkhuyenmai = "/capnhatkhuyenmai";
  static const String themhanghoa = "/themhanghoa";
  static const String timhanghoa = "/timhanghoa";
  static const String layhanghoa = "/layhanghoa";
  static const String capnhathanghoa = "/capnhathanghoa";
  static const String timnhanvien = "/timnhanvien";
  static const String laydanhsachnhanvien = "/laydanhsachnhanvien";
  static const String themnhanvien = "/themnhanvien";
  static const String laythongtinchitietnhanvien =
      "/laythongtinchitietcuanhanvien";
  static const String doithongtinnhanvien = "/doithongtinnhanvien";
  static const String doimatkhaunhanvien = "/doimatkhaunhanvien";
  static const String mohoackhoataikhoan = "/mohoackhoataikhoan";
  static const String laychucvu = "/laychucvu";
  static const String taophieunhaphang = "/taophieunhaphang";
  static const String layphieunhaphang = "/layphieunhaphang";
  static const String laychitietphieunhaphang = "/laychitietphieunhaphang";
  static const String xoaphieunhaphang = "/xoaphieunhaphang";

}
