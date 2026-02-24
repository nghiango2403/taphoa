import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/auth/models/user_model.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<UserModel> login(String tenDangNhap, String matKhau) async {
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {'TenDangNhap': tenDangNhap, 'MatKhau': matKhau},
      );

      final userModel = UserModel.fromJson(response.data);

      if (userModel.status == 200) {
        return userModel;
      } else {
        throw userModel.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "Đã có lỗi xảy ra: $e";
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? "Lỗi xác thực người dùng";
    }
    return "Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.";
  }
}
