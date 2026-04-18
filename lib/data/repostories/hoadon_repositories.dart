import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_them_model.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_chitiet_model.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_model.dart';

class HoaDonRepositories {
  final Dio _dio;

  HoaDonRepositories(this._dio);

  Future<dynamic> themHoaDon(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(Endpoints.themhoadon, data: data);
      if (response.data["status"] == 201) {
        return response.data["data"]["url"];
      }
      final hd = HoaDonThemModel.fromJson(response.data);
      if (hd.status == 200) {
        return hd;
      } else {
        throw hd.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<HoaDonXemModel> laydsHoaDon(Map<String, dynamic> data) async {
    try {
      final response = await _dio.get(
        Endpoints.xemdanhsachhoadon,
        queryParameters: data,
      );
      final hd = HoaDonXemModel.fromJson(response.data);
      if (hd.status == 200) {
        return hd;
      } else {
        throw hd.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<HoaDonXemModel> laydsHoaDonNhanVien(Map<String, dynamic> data) async {
    try {
      final response = await _dio.get(
        Endpoints.xemdanhsachhoadoncuanhanvien,
        queryParameters: data,
      );
      final hd = HoaDonXemModel.fromJson(response.data);
      if (hd.status == 200) {
        return hd;
      } else {
        throw hd.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<HoaDonXemChiTietModel> layChiTietHoaDon(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.get(
        Endpoints.xemchitiethoadon,
        queryParameters: data,
      );
      final hd = HoaDonXemChiTietModel.fromJson(response.data);
      if (hd.status == 200) {
        return hd;
      } else {
        throw hd.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> xoaHoaDon(Map<String, dynamic> data) async {
    try {
      final response = await _dio.delete(Endpoints.xoahoadon, data: data);
      if (response.data["status"] == 200) {
        return true;
      } else {
        throw response.data["message"];
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> layTrangThaiThanhToan(Map<String, dynamic> data) async {
    try {
      final response = await _dio.get(
        Endpoints.kiemtratrangthaithanhtoan,
        queryParameters: data,
      );
      if (response.data["status"] == 200) {
        return response.data["data"];
      } else {
        throw response.data["message"];
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
