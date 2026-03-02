import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/hanghoa_repositories.dart';
import 'package:taphoa/features/admin/hanghoa/models/hanghoa_tong_model.dart';

class HangHoaLogic extends ChangeNotifier {
  final HangHoaRepository  _repository;
  HangHoaLogic(this._repository);

  List<Datum> _listHangHoa = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Datum> get listHangHoa => _listHangHoa;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

      final result = await _repository.timHangHoa(ten);

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

      await fetchHangHoa();

      onSuccess();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}