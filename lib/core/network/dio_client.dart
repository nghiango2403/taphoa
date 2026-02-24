import 'package:dio/dio.dart';
import 'package:taphoa/core/network/api_endpoints.dart';
import 'package:taphoa/core/services/storage_service.dart';

class DioClient {
  late Dio _dio;
  final StorageService _storageService = StorageService();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final success = await _refreshToken();

            if (success) {
              final newToken = await _storageService.getAccessToken();
              final options = e.requestOptions;
              options.headers["Authorization"] = "Bearer $newToken";

              final response = await _dio.fetch(options);
              return handler.resolve(response);
            } else {
              _handleLogout();
            }
          }
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        Endpoints.baseUrl + Endpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['accessToken'];
        final newRole = response.data['data']['ThongTin']['ChucVu'];

        await _storageService.saveAccessToken(newAccessToken);
        await _storageService.saveRole(newRole);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _handleLogout() {
    _storageService.clearAll();
    print("Phiên đăng nhập hết hạn, vui lòng đăng nhập lại.");
  }

  Dio get dio => _dio;
}
