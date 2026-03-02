import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/nhanvien_repositories.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_laychitiet_model.dart';
import 'package:taphoa/features/admin/nhanvien/models/nhanvien_tong_model.dart';

class NhanVienLogic extends ChangeNotifier {
  final NhanVienRepository _repository;

  NhanVienLogic(this._repository);

  List<Danhsach> _listNhanVien = [];
  bool _isLoading = false;
  String? _errorMessage;
  NhanVienLayChiTietModel? _nhanVienChiTiet;

  NhanVienLayChiTietModel? get nhanVienChiTiet => _nhanVienChiTiet;

  int _currentPage = 1;
  int _pageSize = 5;

  List<Danhsach> get listNhanVien => _listNhanVien;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;

  Future<void> fetchNhanVien({int? trang}) async {
    if (trang != null) _currentPage = trang;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.layDanhSachNhanVien(
        trang: _currentPage,
        dong: _pageSize,
      );

      _listNhanVien = result.data.danhsach.cast<Danhsach>();
    } catch (e) {
      _errorMessage = e.toString();
      _listNhanVien = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchNhanVien(String ten) async {
    if (ten.isEmpty) {
      _currentPage = 1;
      return fetchNhanVien();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.timNhanVien(ten);
      _listNhanVien = result.data.danhsach.cast<Danhsach>();
    } catch (e) {
      _errorMessage = e.toString();
      _listNhanVien = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNhanVien(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.themNhanVien(data);

      if (res.status == 200 || res.status == 201) {
        await fetchNhanVien(trang: 1);
        return true;
      } else {
        _errorMessage = res.message ?? "Thêm thất bại, vui lòng thử lại.";
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateNhanVien(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      final res = await _repository.suaNhanVien(data);

      if (res.status == 200) {

        await fetchNhanVien(trang: 1);
        return true;
      } else {
        _errorMessage = res.message ?? "Cập nhật thất bại, vui lòng thử lại.";
        return false;
      }
    } catch (e) {

      _errorMessage = e.toString();
      return false;
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchChiTietNhanVien(String MaTaiKhoan) async {
    _isLoading = true;
    _errorMessage = null;
    _nhanVienChiTiet = null;
    notifyListeners();

    try {

      final res = await _repository.layChiTietNhanVien(MaTaiKhoan);

      if (res.status == 200) {
        _nhanVienChiTiet = res;
        return true;
      } else {
        _errorMessage = res.message ?? "Không thể lấy thông tin chi tiết.";
        return false;
      }
    } catch (e) {

      _errorMessage = e.toString();
      return false;
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleDoiMatKhau(String id, String newPass) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool ok = await _repository.doiMatKhau(id, newPass);
      return ok;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleToggleStatus(String maTaiKhoan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await _repository.khooMoTaiKhoan(maTaiKhoan);

      if (success) {
        await fetchNhanVien(trang: currentPage);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (page < 1) return;
    _currentPage = page;
    fetchNhanVien();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
