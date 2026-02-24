import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/account/models/account_get_model.dart';

class AccountRepository {
  final Dio _dio;

  AccountRepository(this._dio);
  Future<AccountGetModel> GetInfoUser() async {
    try {
      final response = await _dio.get(Endpoints.laythongtintaikhoan);
      final user = AccountGetModel.fromJson(response.data);
      if (user.status == 200) {
        return user;
      } else {
        throw user.message;
      }
      return AccountGetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? "Lỗi";
    }
    return "Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.";
  }
}
