import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLogin = false;

  bool get isLoading => _isLoading;

  bool get isLogin => _isLoading;


  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.authenticate(phone, password);

      _isLogin = success;
      return success;
    } catch (e) {
      _isLogin = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLogin = false;
    notifyListeners();
  }
}
