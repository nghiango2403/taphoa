import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/data/models/chucvu_model.dart';

class ChucVuRepository {
  final Dio _dio;

  ChucVuRepository(this._dio);

  Future<List<Datum>> layDanhSachChucVu() async {
    try {
      final response = await _dio.get(Endpoints.laychucvu);

      final model = ChucVuModel.fromJson(response.data);

      if (model.status == 200) {
        return model.data;
      } else {
        throw model.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? "Lỗi hệ thống khi lấy chức vụ";
    }
    return "Lỗi kết nối server (Chức vụ)";
  }
}