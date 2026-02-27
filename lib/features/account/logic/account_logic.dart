import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/account_repositories.dart';
import 'package:taphoa/features/account/models/account_get_model.dart';

class AccountLogic extends ChangeNotifier {
  final AccountRepository _repository;

  AccountGetModel? _accountData;
  bool _isLoading = false;
  String? _errorMessage;

  AccountLogic(this._repository);

  AccountGetModel? get accountData => _accountData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    _accountData = null;
    notifyListeners();

    try {
      _accountData = await _repository.GetInfoUser();
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint("Error fetching profile: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.UpdateInfoUser(updateData);
      if (response.status == 200 && _accountData != null) {
        _accountData!.data.hoTen = updateData["HoTen"];
        _accountData!.data.sdt = updateData["SDT"];
        _accountData!.data.email = updateData["Email"];
        _accountData!.data.ngaySinh = DateTime.parse(updateData["NgaySinh"]);
        _accountData!.data.diaChi = updateData["DiaChi"];
        _accountData!.data.gioiTinh = updateData["GioiTinh"];
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint("Lỗi khi cập nhật: $_errorMessage");
      rethrow;
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
