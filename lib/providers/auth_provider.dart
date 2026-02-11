import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ichat/services/api_service.dart';
import 'package:ichat/features/chats/models/contact_model.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  List users = [];

  int? _userID;

  int? get userID => _userID;

  set userId(int? id) {
    _userID = id;
    notifyListeners();
  }

  List<int> _discussionContacts = [];

  List<int> get discussionContacts => _discussionContacts;


  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  String? _number = '';

  final Map _token = {};
  Map get token => _token;

  String? get number => _number;

  bool _isLoading = false;

  bool _isLogin = false;

  bool get isLoading => _isLoading;

  bool get isLogin => _isLogin;

  Future<void> loadToken() async {
    if (!_isLogin || _number == null) {
      _token.clear();
      return;
    }

    final data = await _apiService.fetchToken(_number.toString());
    _token.clear();
    _token.addAll(data); // 👈 extraction du token
  }

  Future<bool> login(String valueNum) async {
    _isLoading = true;
    _number = valueNum;
    notifyListeners();

    try {
      final success = await _apiService.login(valueNum);
      if (success != null) {
        _userID = success;
        notifyListeners();
        _isLogin = true;
      } else {
        await _apiService.sendOtp(valueNum);
      }
      return success != null;
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

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    // ignore: avoid_print
    print('Vérification du code OTP pour le numéro $phone avec le code $otp');

    notifyListeners();

    final success = await _apiService.verifyOtp(phone, otp);
    print('Résultat de la vérification OTP : $success');
    _isLoading = false;
    notifyListeners();
    if (success) {
      _isLogin = true;
      notifyListeners();
      loadToken();
      notifyListeners();
      _isLoading = false;
      print('Token chargé : $_token');
    }
    notifyListeners();

    return success;
  }

  // Créer un nouveau contact
  Future<void> addContact(String name, String phone) async {
    if (_userID == null) return;

    try {
      final contact = await _apiService.createContact(_userID!, name, phone);
      _contacts.add(contact);
      notifyListeners();
    } catch (e) {
      print("Erreur création contact : $e");
    }
  }

  // Charger les contacts
  Future<void> fetchMyContacts() async {
    if (_userID == null) return;

    try {
      _contacts = await _apiService.getMyContacts(_userID!);
      notifyListeners();
    } catch (e) {
      print("Erreur fetch contacts : $e");
    }
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

 
Future<void> fetchDiscussions() async {
  if (_userID == null) return;

  try {
    _discussionContacts =
        await _apiService.getMyDiscussions(_userID!);
    notifyListeners();
  } catch (e) {
    print("Erreur fetch discussions: $e");
  }
}

}
