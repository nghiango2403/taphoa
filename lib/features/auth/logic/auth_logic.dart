import 'package:flutter/material.dart';
import 'package:taphoa/core/services/storage_service.dart';
import 'package:taphoa/data/repostories/auth_repositories.dart';
import 'package:taphoa/features/auth/models/user_model.dart';

class AuthLogic extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthLogic(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;
  bool _isObscured = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isObscured => _isObscured;
  bool _isLoggedOut = false;
  bool get isLoggedOut => _isLoggedOut;
  String? accessToken;
  String? refreshToken;
  String? role;
  bool isInitialized = false;

  void toggleObscure() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(username, password);
      if (_user != null) {
        final storage = StorageService();
        await storage.saveAccessToken(_user!.data.accessToken);
        await storage.saveRefreshToken(_user!.data.refreshToken);
        await storage.saveRole(_user!.data.thongTin.chucVu);

        print("Đã lưu token bảo mật thành công!");
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedOut = true;
    _user = null;
    notifyListeners();
  }

  Future<void> loadSavedAuth() async {
    final storage = StorageService();
    accessToken = await storage.getAccessToken();
    refreshToken = await storage.getRefreshToken();
    role = await storage.getRole();

    isInitialized = true;
    notifyListeners();
  }
}
