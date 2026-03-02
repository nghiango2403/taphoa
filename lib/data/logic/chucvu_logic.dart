import 'package:flutter/material.dart';
import 'package:taphoa/data/repostories/chucvu_repositories.dart';

import '../models/chucvu_model.dart';

class ChucVuLogic extends ChangeNotifier {
  final ChucVuRepository _repository;

  ChucVuLogic(this._repository);

  List<Datum> _listChucVu = [];
  bool _isLoading = false;
  String? _errorMessage;
  Datum? _selectedChucVu;

  List<Datum> get listChucVu => _listChucVu;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Datum? get selectedChucVu => _selectedChucVu;

  Future<void> fetchChucVu() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listChucVu = await _repository.layDanhSachChucVu();
    } catch (e) {
      _errorMessage = e.toString();
      _listChucVu = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setChucVu(Datum? value) {
    _selectedChucVu = value;
    notifyListeners();
  }

  void resetSelection() {
    _selectedChucVu = null;
    _errorMessage = null;
    notifyListeners();
  }
}