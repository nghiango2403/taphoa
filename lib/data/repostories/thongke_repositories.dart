import 'package:dio/dio.dart';
import 'package:taphoa/features/admin/thongke/models/thongkebanhang_model.dart';
import 'package:taphoa/features/admin/thongke/models/thongkedoanhtho_model.dart';
import 'package:taphoa/features/admin/thongke/models/thongkenhaphang_model.dart';
import 'package:taphoa/features/admin/thongke/models/thongketonkho_model.dart';

import '../../core/network/api_endpoints.dart';

class ThongKeRepositories {
  final Dio _dio;

  ThongKeRepositories(this._dio);

  /// Lấy thống kê tồn kho theo tháng và năm.
  ///
  /// Gửi request GET tới API [Endpoints.thongketonkho]
  /// với query parameters:
  /// - `thang`: tháng cần thống kê
  /// - `nam`: năm cần thống kê
  ///
  /// Trả về một đối tượng [ThongKeTonKhoModel].
  ///
  /// Throws:
  /// - `Exception` nếu API trả về status khác 200.
  /// - `DioException` nếu xảy ra lỗi mạng hoặc server.
  /// - `String` nếu lỗi được xử lý từ `_handleDioError`.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.layThongKeTonKho({
  ///   thang: 5,
  ///   nam: 2025,
  /// });
  /// ```
  Future<ThongKeTonKhoModel> layThongKeTonKho({
    required int thang,
    required int nam,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.thongketonkho,
        queryParameters: {"thang": thang, "nam": nam},
      );

      if (response.statusCode == 200) {
        return ThongKeTonKhoModel.fromJson(response.data);
      } else {
        throw "Lấy thống kê tồn kho thất bại";
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Lấy thống kê doanh thu từ ngày bắt đầu đến ngày kết thúc.
  ///
  /// Gửi request GET tới API [Endpoints.thongkedoanhthu]
  /// với query parameters:
  /// - `ngaybatdau`: ngày bắt đầu cần thống kê
  /// - `ngayketthuc`: ngày kết thúc cần thống kê
  ///
  /// Trả về một đối tượng [ThongKeDoanhThuModel].
  ///
  /// Throws:
  /// - `Exception` nếu API trả về status khác 200.
  /// - `DioException` nếu xảy ra lỗi mạng hoặc server.
  /// - `String` nếu lỗi được xử lý từ `_handleDioError`.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.layThongKeDoanhThu(
  ///   ngaybatdau: 2025-1-17,
  ///   ngayketthuc: 2025-2-17,
  /// );
  /// ```
  Future<ThongKeDoanhThuModel> layThongKeDoanhThu({
    required String ngaybatdau,
    required String ngayketthuc,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.thongkedoanhthu,
        queryParameters: {"ngaybatdau": ngaybatdau, "ngayketthuc": ngayketthuc},
      );

      if (response.statusCode == 200) {
        return ThongKeDoanhThuModel.fromJson(response.data);
      } else {
        throw "Lấy thống kê doanh thu thất bại";
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Lấy thống kê nhập hàngtheo tháng và năm.
  ///
  /// Gửi request GET tới API [Endpoints.thongkenhaphang]
  /// với query parameters:
  /// - `thang`: tháng cần thống kê
  /// - `nam`: năm cần thống kê
  ///
  /// Trả về một đối tượng [ThongKeNhapHangModel].
  ///
  /// Throws:
  /// - `Exception` nếu API trả về status khác 200.
  /// - `DioException` nếu xảy ra lỗi mạng hoặc server.
  /// - `String` nếu lỗi được xử lý từ `_handleDioError`.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.layThongKeNhapHang({
  ///   thang: 5,
  ///   nam: 2025,
  /// });
  /// ```
  Future<ThongKeNhapHangModel> layThongKeNhapHang({
    required int thang,
    required int nam,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.thongkenhaphang,
        queryParameters: {"thang": thang, "nam": nam},
      );

      if (response.statusCode == 200) {
        return ThongKeNhapHangModel.fromJson(response.data);
      } else {
        throw "Lấy thống kê nhập hàng thất bại";
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Lấy thống kê bán hàng theo tháng và năm.
  ///
  /// Gửi request GET tới API [Endpoints.thongkebanhang]
  /// với query parameters:
  /// - `thang`: tháng cần thống kê
  /// - `nam`: năm cần thống kê
  ///
  /// Trả về một đối tượng [ThongKeBanHangModel].
  ///
  /// Throws:
  /// - `Exception` nếu API trả về status khác 200.
  /// - `DioException` nếu xảy ra lỗi mạng hoặc server.
  /// - `String` nếu lỗi được xử lý từ `_handleDioError`.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.layThongKeBanHang({
  ///   thang: 5,
  ///   nam: 2025,
  /// });
  /// ```
  Future<ThongKeBanHangModel> layThongKeBanHang({
    required int thang,
    required int nam,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.thongkebanhang,
        queryParameters: {"thang": thang, "nam": nam},
      );

      if (response.statusCode == 200) {
        return ThongKeBanHangModel.fromJson(response.data);
      } else {
        throw "Lấy thống kê bán hàng thất bại";
      }
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
