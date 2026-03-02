import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_laychitiet_model.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_sua.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_them.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_tong_model.dart';

class NhanVienRepository {
  final Dio _dio;

  NhanVienRepository(this._dio);

  Future<NhanVienTongModel> layDanhSachNhanVien({
    int trang = 1,
    int dong = 10,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.laydanhsachnhanvien,
        queryParameters: {"Trang": trang, "Dong": dong},
      );

      return NhanVienTongModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<NhanVienTongModel> timNhanVien(String ten) async {
    try {
      final response = await _dio.get(
        Endpoints.timnhanvien,
        queryParameters: {
          "TenNhanVien": ten,
        },
      );
      return NhanVienTongModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<NhanVienThemModel> themNhanVien(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(Endpoints.themnhanvien, data: data);
      final nv = NhanVienThemModel.fromJson(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return nv;
      }
      throw nv.message;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<NhanVienSuaModel> suaNhanVien(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        Endpoints.doithongtinnhanvien,
        queryParameters: data,
      );

      final result = NhanVienSuaModel.fromJson(response.data);

      if (response.statusCode == 200) {
        return result;
      } else {
        throw result.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<NhanVienLayChiTietModel> layChiTietNhanVien(String id) async {
    try {
      final response = await _dio.get(
        Endpoints.laythongtinchitietnhanvien,
        queryParameters: {"MaTaiKhoan": id},
      );

      if (response.statusCode == 200) {
        return NhanVienLayChiTietModel.fromJson(response.data);
      } else {
        throw "Không thể lấy thông tin chi tiết nhân viên";
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> doiMatKhau(String id, String matKhauMoi) async {
    try {
      final response = await _dio.put(
        Endpoints.doimatkhaunhanvien,
        queryParameters: {"MaTaiKhoan": id, "MatKhau": matKhauMoi},
      );
      return response.statusCode == 200;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> khooMoTaiKhoan(String maTaiKhoan) async {
    try {
      final response = await _dio.put(
        Endpoints.mohoackhoataikhoan,
        queryParameters: {"MaTaiKhoan": maTaiKhoan},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? "Lỗi hệ thống";
    }
    return "Lỗi kết nối server";
  }
}
