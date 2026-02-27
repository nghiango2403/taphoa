import 'package:flutter/widgets.dart';
import 'package:taphoa/data/repostories/khuyenmai_repositories.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_them_model.dart';
import 'package:taphoa/features/admin/khuyenmai/models/khuyenmai_tong_model.dart';

class KhuyenMaiLogic extends ChangeNotifier {
  final KhuyenMaiRepository _repository;
  KhuyenMaiLogic(this._repository);

  KhuyenMaiTongModel? _khuyenMaiData;
  bool _isLoading = false;
  String? errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Danhsach> get listKhuyenMai => _khuyenMaiData?.data.danhsach ?? [];
  int get tongSoTrang => _khuyenMaiData?.data.sotrang ?? 1;

  Future<void> fetchKhuyenMai(Map<String, dynamic> data) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _khuyenMaiData = await _repository.layKhuyenMai(data);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> themKhuyenMai(Map<String, dynamic> data, {required Function onSuccess}) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.themKhuyenMai(data);
      await fetchKhuyenMai({
        "Trang": 1,
        "Dong": 10,
      });
      onSuccess();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> suaKhuyenMai(String id, Map<String, dynamic> data, {required Function onSuccess}) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.suaKhuyenMai(id, data);

      await fetchKhuyenMai({"Trang": 1, "Dong": 10});

      onSuccess();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
