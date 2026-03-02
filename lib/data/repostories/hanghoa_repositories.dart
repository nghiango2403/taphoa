import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/features/admin/hanghoa/models/hanghoa_sua_model.dart';
import 'package:taphoa/features/admin/hanghoa/models/hanghoa_tong_model.dart';

class HangHoaRepository {
  final Dio _dio;

  HangHoaRepository(this._dio);

  Future<HangHoaTongModel> layHangHoa() async {
    try {
      final response = await _dio.get(Endpoints.layhanghoa);
      final hh = HangHoaTongModel.fromJson(response.data);
      if (hh.status == 200) {
        return hh;
      } else {
        throw hh.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<HangHoaTongModel> timHangHoa(String Ten) async {
    try {
      final response = await _dio.get(Endpoints.timhanghoa, queryParameters: {"Ten":Ten});
      final hh = HangHoaTongModel.fromJson(response.data);
      if (hh.status == 200) {
        return hh;
      } else {
        throw hh.message;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<HangHoaSuaModel> suaHangHoa(String id, Map<String, dynamic> data) async {
    try {

      final Map<String, dynamic> queryParams = {
        "MaHangHoa": id,
        "Ten": data["Ten"],
        "Gia": data["Gia"],
      };

      final response = await _dio.put(
        Endpoints.capnhathanghoa,
        queryParameters: queryParams,
      );

      final result = HangHoaSuaModel.fromJson(response.data);

      if (result.status == 200) {
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
  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? "Lỗi";
    }
    return "Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.";
  }
}
