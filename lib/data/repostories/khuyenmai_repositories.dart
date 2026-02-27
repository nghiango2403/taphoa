import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_sua_model.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_them_model.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_tong_model.dart';

class KhuyenMaiRepository {
  final Dio _dio;

  KhuyenMaiRepository(this._dio);

  Future<KhuyenMaiTongModel> layKhuyenMai(Map<String, dynamic> data) async {
    try {
      final response = await _dio.get(Endpoints.laykhuyenmai, queryParameters: data);
      final km = KhuyenMaiTongModel.fromJson(response.data);
      if (km.status == 200) {
        return km;
      } else {
        throw km.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<KhuyenMaiThemModel> themKhuyenMai(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(Endpoints.themkhuyenmai,data: data);
      final km = KhuyenMaiThemModel.fromJson(response.data);
      if (km.status == 200) {
        return km;
      } else {
        throw km.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<KhuyenMaiSuaModel> suaKhuyenMai(String id, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> queryParams = {
        "MaKhuyenMai": id,
        ...data, // Giải nén các trường TenKhuyenMai, NgayBatDau... vào đây
      };

      final response = await _dio.put(
        Endpoints.capnhatkhuyenmai,
        queryParameters: queryParams,
      );

      final km = KhuyenMaiSuaModel.fromJson(response.data);

      if (km.status == 200) {
        return km;
      } else {
        throw km.message;
      }
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
