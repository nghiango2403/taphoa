import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/hoadon_repositories.dart';
import 'package:taphoa/data/repostories/khuyenmai_repositories.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_them_model.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_chitiet_model.dart';
import 'package:taphoa/features/admin/hoadon/models/hoadon_xem_model.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_laybangid_model.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_xem_conhoatdong_model.dart';

class HoaDonLogic extends ChangeNotifier {
  final HoaDonRepositories _repository;
  final KhuyenMaiRepository _reKM;

  HoaDonLogic(this._repository, this._reKM);

  List<Danhsach> _listKhuyenMai = [];

  List<Danhsach> get listKhuyenMai => _listKhuyenMai;

  List<Item> _listHoaDon = [];

  List<Item> get listHoaDon => _listHoaDon;

  bool _kmIsLoading = false;

  bool get kmIsLoading => _kmIsLoading;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _ctIsLoading = false;

  bool get CTIsLoading => _ctIsLoading;

  String? _errorMessage = "";

  String? get errorMessage => _errorMessage;

  int _currentPage = 1;
  int _totalPages = 1;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  List<Datum> _info = [];

  List<Datum> get info => _info;

  DataKhuyenMai? _infokhuyenmai;

  DataKhuyenMai? get infokhuyenmai => _infokhuyenmai;
  String? _qrUrl;

  String? get qrUrl => _qrUrl;

  String _trangThaiThanhToan = "Đang tải...";

  String get trangThaiThanhToan => _trangThaiThanhToan;

  // Lưu trữ bộ lọc để dùng khi chuyển trang
  String? _currentThang;
  String? _currentNam;
  int _pageSize = 10;

  Future<void> layDsKhuyenMaiConHoatDong() async {
    _isLoading = true;
    notifyListeners();
    try {
      KhuyenMaiXemConHoatDongModel res = await _reKM.layKhuyenMaiConHoatDong();
      _listKhuyenMai = res.data.danhsach;
    } catch (e) {
      _errorMessage = e.toString();
      _listKhuyenMai = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> ThemHoaDon(Map<String, dynamic> dataFromUI) async {
    try {
      _isLoading = true;
      _qrUrl = null;
      notifyListeners();
      final List<Map<String, dynamic>> chiTiet =
          (dataFromUI["ChiTietHD"] as List).map((item) {
            return {
              "MaHangHoa": item['MaHangHoa'],
              "SoLuong": item['SoLuong'],
              "Gia": item['Gia'],
            };
          }).toList();

      final dynamic km = dataFromUI['MaKhuyenMai'];
      final String? maKM = (km is Danhsach) ? km.id : null;

      final Map<String, dynamic> data = {
        "MaKhuyenMai": maKM,
        "ChiTietHD": chiTiet,
        "HinhThucThanhToan": dataFromUI['HinhThucThanhToan'],
      };
      dynamic res = await _repository.themHoaDon(data);
      if (res is String) {
        _qrUrl = res;
        return true;
      } else if (res is HoaDonThemModel && res.status == 200) {
        return true;
      } else {
        _errorMessage = "Có lỗi xảy ra";
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

  Future<void> layDanhSachHoaDon({
    int page = 1,
    String? thang,
    String? nam,
    int? dong,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentPage = page;
      _currentThang = thang ?? _currentThang;
      _currentNam = nam ?? _currentNam;
      _pageSize = dong ?? _pageSize;

      // Chuẩn bị params gửi lên Repository
      Map<String, dynamic> params = {
        "Trang": _currentPage,
        "Dong": _pageSize,
        "Thang": _currentThang,
        "Nam": _currentNam,
      };

      // Loại bỏ các key null để URL sạch hơn
      params.removeWhere((key, value) => value == null || value == "");

      final res = await _repository.laydsHoaDon(params);

      if (res.status == 200) {
        _listHoaDon = res.data.danhsach;
        _totalPages = res.data.soTrang;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> layDanhSachHoaDonNhanVien({
    int page = 1,
    String? thang,
    String? nam,
    int? dong,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentPage = page;
      _currentThang = thang ?? _currentThang;
      _currentNam = nam ?? _currentNam;
      _pageSize = dong ?? _pageSize;

      // Chuẩn bị params gửi lên Repository
      Map<String, dynamic> params = {
        "Trang": _currentPage,
        "Dong": _pageSize,
        "Thang": _currentThang,
        "Nam": _currentNam,
      };

      // Loại bỏ các key null để URL sạch hơn
      params.removeWhere((key, value) => value == null || value == "");

      final res = await _repository.laydsHoaDonNhanVien(params);

      if (res.status == 200) {
        _listHoaDon = res.data.danhsach;
        _totalPages = res.data.soTrang;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> layChiTietHoaDon({String? maHoaDon}) async {
    try {
      _ctIsLoading = true;
      notifyListeners();

      final res = await _repository.layChiTietHoaDon({"MaHoaDon": maHoaDon});
      _trangThaiThanhToan = await _repository.layTrangThaiThanhToan({
        'MaHoaDon': maHoaDon,
      });

      if (res.status == 200) {
        _info = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _ctIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> layThongTinKhuyenMai({String maKhuyenMai = ''}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = await _reKM.layKhuyenMaiBangId(maKhuyenMai);

      if (res.status == 200) {
        _infokhuyenmai = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> xoaHoaDon(String maHoaDon) async {
    try {
      _ctIsLoading = true;
      notifyListeners();

      return await _repository.xoaHoaDon({'MaHoaDon': maHoaDon});
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _ctIsLoading = false;
      notifyListeners();
    }
  }
}
