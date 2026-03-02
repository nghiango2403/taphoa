import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/nhaphang_repositories.dart';
import 'package:taphoa/features/admin/nhaphang/models/nhaphang_lay_tong.dart';

import '../models/nhaphang_lay_chitiet_model.dart';

class NhapHangLogic extends ChangeNotifier {
  final NhapHangRepository _repository;

  NhapHangLogic(this._repository);

  List<Danhsach> _listPhieu = [];

  List<Danhsach> get listPhieu => _listPhieu;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _currentPage = 1;

  int get currentPage => _currentPage;

  int _totalPage = 1;

  int get totalPage => _totalPage;
  String? _errorMessage = "";

  String? get errorMessage => _errorMessage;
  List<Datum> _listChiTiet = [];

  List<Datum> get listChiTiet => _listChiTiet;

  Future<void> fetchPhieuNhap({
    int trang = 1,
    required int thang,
    required int nam,
  }) async {
    _isLoading = true;
    _currentPage = trang;
    notifyListeners();

    try {
      final res = await _repository.layPhieuNhapHang(
        trang: trang,
        dong: 10,
        thang: thang,
        nam: nam,
      );

      if (res.status == 200) {
        _listPhieu = res.data.danhsach;
        _totalPage = res.data.sotrang;
      }
    } catch (e) {
      debugPrint("Lỗi Nhập Hàng: $e");
      _listPhieu = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleThemPhieuNhap(
    List<Map<String, dynamic>> selectedItems,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {

      final List<Map<String, dynamic>> danhSachGui = selectedItems.map((item) {
        return {
          "MaHangHoa": item['id'],
          "SoLuong": item['soluong'],
          "TienHang": item['gianhap'],
        };
      }).toList();

      final body = {"DanhSach": danhSachGui};

      bool success = await _repository.themPhieuNhap(body);
      fetchPhieuNhap(thang: DateTime.now().month, nam: DateTime.now().year);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchChiTietPhieu(String maPhieu) async {
    _isLoading = true;
    _listChiTiet = [];
    notifyListeners();

    try {
      final res = await _repository.layChiTietPhieuNhap(maPhieu);
      if (res.status == 200) {
        _listChiTiet = res.data.cast<Datum>();
      }
    } catch (e) {
      debugPrint("Lỗi lấy chi tiết: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleXoaPhieu(String maPhieu) async {
    try {
      bool success = await _repository.xoaPhieuNhap(maPhieu);
      if (success) {
        _listPhieu.removeWhere((item) => item.id == maPhieu);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}
