import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/admin/nhaphang/models/nhaphang_lay_tong.dart';

import '../../features/admin/nhaphang/models/nhaphang_lay_chitiet_model.dart';

class NhapHangRepository {
  final Dio _dio;

  NhapHangRepository(this._dio);

  Future<PhieuNhapHangLayModel> layPhieuNhapHang({
    required int trang,
    required int dong,
    required int thang,
    required int nam,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.layphieunhaphang,
        queryParameters: {
          "Trang": trang,
          "Dong": dong,
          "Thang": thang,
          "Nam": nam,
        },
      );

      if (response.statusCode == 200) {
        return PhieuNhapHangLayModel.fromJson(response.data);
      } else {
        throw "Lấy danh sách phiếu nhập thất bại";
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> themPhieuNhap(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(Endpoints.taophieunhaphang, data: body);

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Lỗi khi lưu phiếu nhập";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<NhapHangLayChiTietModel> layChiTietPhieuNhap(String maPhieu) async {
    try {
      final response = await _dio.get(
        Endpoints.laychitietphieunhaphang,

        queryParameters: {"MaPhieuNhapHang": maPhieu},
      );

      if (response.statusCode == 200) {
        return NhapHangLayChiTietModel.fromJson(response.data);
      } else {
        throw "Không thể lấy chi tiết phiếu nhập";
      }
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Lỗi kết nối Server";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> xoaPhieuNhap(String maPhieu) async {
    try {
      final response = await _dio.delete(
        Endpoints.xoaphieunhaphang,
        data: {"MaPhieuNhapHang": maPhieu},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Không thể xóa phiếu nhập";
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
