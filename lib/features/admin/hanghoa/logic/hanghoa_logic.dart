import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/hanghoa_repositories.dart';
import 'package:taphoa/features/admin/hanghoa/models/hanghoa_tong_model.dart';

class HangHoaLogic extends ChangeNotifier {
  final HangHoaRepository  _repository;
  HangHoaLogic(this._repository);

  // State
  List<Datum> _listHangHoa = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Datum> get listHangHoa => _listHangHoa;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Hàm lấy danh sách hàng hóa
  Future<void> fetchHangHoa() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.layHangHoa();
      _listHangHoa = result.data;
    } catch (e) {
      _errorMessage = e.toString();
      _listHangHoa = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> searchHangHoa(String ten) async {
    if (ten.isEmpty) {
      return fetchHangHoa();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Gọi hàm tìm kiếm từ repository
      final result = await _repository.timHangHoa(ten);

      // Bây giờ cả hai đều cùng kiểu dữ liệu nên gán thoải mái không bị lỗi nữa
      _listHangHoa = result.data;
    } catch (e) {
      _errorMessage = e.toString();
      _listHangHoa = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
}
  Future<void> suaHangHoa(String id, Map<String, dynamic> data, {required Function onSuccess}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.suaHangHoa(id, data);

      // Cập nhật lại danh sách hàng hóa ngay lập tức
      await fetchHangHoa();

      onSuccess();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Hàm xóa thông báo lỗi (Dùng khi người dùng chuyển trang hoặc đóng thông báo)
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}