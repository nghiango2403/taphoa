import 'package:flutter/cupertino.dart';
import 'package:taphoa/data/repostories/thongke_repositories.dart';
import 'package:taphoa/features/admin/thongke/models/thongkebanhang_model.dart';
import 'package:taphoa/features/admin/thongke/models/thongkedoanhtho_model.dart';
import 'package:taphoa/features/admin/thongke/models/thongketonkho_model.dart';

import '../models/thongkenhaphang_model.dart';

class ThongKeLogic extends ChangeNotifier {
  final ThongKeRepositories _repository;

  ThongKeLogic(this._repository);

  /// Trạng thái biểu thị quá trình xử lý dữ liệu đang diễn ra (ví dụ: gọi API, truy vấn DB).
  /// Sử dụng [isLoading] để hiển thị loading indicator trên UI.
  bool _isLoading = false;

  /// Getter công khai để các widget theo dõi trạng thái tải dữ liệu.
  bool get isLoading => _isLoading;

  /// Lưu trữ thông báo lỗi nếu có sự cố xảy ra trong quá trình thực thi.
  /// Giá trị là `null` nếu không có lỗi.
  String? _errorMessage;

  /// Getter để UI truy xuất và hiển thị thông báo lỗi cho người dùng.
  String? get errorMessage => _errorMessage;

  List<Datum1> _listBanHang = [];
  List<Datum2> _listDoanhThu = [];
  List<Datum3> _listNhapHang = [];
  List<Datum4> _listTonKho = [];

  List<Datum1> get listBanHang => _listBanHang;

  List<Datum2> get listDoanhThu => _listDoanhThu;

  List<Datum3> get listNhapHang => _listNhapHang;

  List<Datum4> get listTonKho => _listTonKho;

  Future<void> fetchThongKeBanHang(int thang, int nam) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final res = await _repository.layThongKeBanHang(thang: thang, nam: nam);
      if (res.status == 200) {
        _listBanHang = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _listNhapHang = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchThongKeDoanhThu(
    String ngaybatdau,
    String ngayketthuc,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final res = await _repository.layThongKeDoanhThu(
        ngaybatdau: ngaybatdau,
        ngayketthuc: ngayketthuc,
      );
      print(res);
      if (res.status == 200) {
        _listDoanhThu = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _listNhapHang = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchThongKeNhapHang(int thang, int nam) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final res = await _repository.layThongKeNhapHang(thang: thang, nam: nam);
      if (res.status == 200) {
        _listNhapHang = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _listNhapHang = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchThongKeTonKho(int thang, int nam) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final res = await _repository.layThongKeTonKho(thang: thang, nam: nam);
      if (res.status == 200) {
        _listTonKho = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _listNhapHang = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
