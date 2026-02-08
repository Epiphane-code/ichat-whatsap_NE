import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  List users = [];

  bool _isLoading = false;

  bool _isLogin = false;

  bool get isLoading => _isLoading;

  bool get isLogin => _isLogin;

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

  Future<bool> register(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulation API

    _isLoading = false;
    notifyListeners();

    return true; // succès
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    return otp == "123456"; // OTP simulé
  }

  Future<List> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    if (_isLogin) {
      final fetchedUsers = await _apiService.fetchUsers();
      users = fetchedUsers;
      notifyListeners();
      return users;
    }

    _isLoading = false;
    notifyListeners();
    return users; // retourne la liste des utilisateurs
  }
}
