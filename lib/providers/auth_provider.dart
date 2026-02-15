import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ichat/features/chats/models/messageModel.dart';
import 'package:ichat/services/api_service.dart';
import 'package:ichat/features/chats/models/contact_model.dart';
import 'package:ichat/features/chats/models/discussionsModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List users = [];

  WebSocketChannel? channel;

  int? _userID;

  int? get userID => _userID;

  set userId(int? id) {
    _userID = id;
    notifyListeners();
  }

  List<Discussion> _discussionContacts = [];

  List<Discussion> get discussionContacts => _discussionContacts;

  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

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

  void listenWebSocket() {
    if (_userID == null) {
      print("WS annulé : userID null");
      return;
    }

    if (channel != null) {
      print("WS déjà connecté");
      return;
    }

    final url = 'ws://10.249.240.125:8000/websocket/ws/$_userID';
    print("Connexion WS → $url");

    try {
      channel = WebSocketChannel.connect(Uri.parse(url));

      print('WS connecté');

      channel!.stream.listen(
        (data) {
          print("WS DATA: $data");

          final jsonData = jsonDecode(data);

          if (jsonData['type'] == 'new_message') {
            fetchMessages(jsonData["discussion_id"]); // 🔥 refresh liste discussions
          }
        },
        onError: (error) {
          print("WS ERROR: $error");
          channel = null; // 🔥 permet de reconnecter plus tard
        },
        onDone: () {
          print("WS CLOSED");
          channel = null;
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("WS EXCEPTION: $e");
      channel = null;
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
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
    _isLoading = false;
    notifyListeners();
    if (success) {
      _isLogin = true;
      notifyListeners();
      loadToken();
      notifyListeners();
      _isLoading = false;
    }
    notifyListeners();

    return success;
  }

  // Créer un nouveau contact
  Future<void> addContact(String name, String phone) async {
    if (_userID == null) {
      print('ID nul');
      return;
    }

    try {
      final contact = await _apiService.createContact(_userID!, name, phone);
      print('creation de contact envoye depuis provider');
      _contacts.add(contact);
      notifyListeners();
      // ignore: avoid_print
    } catch (e) {
      print('ERROR : {$e}');
    }
  }

  // Charger les contacts
  Future<void> fetchMyContacts() async {
    if (_userID == null) return;

    try {
      _contacts = await _apiService.getMyContacts(_userID!);
      notifyListeners();
      // ignore: avoid_print
    } catch (e) {
      print('ERROR : {$e}');
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
      _discussionContacts = await _apiService.getMyDiscussions(_userID!);
      notifyListeners();
    } catch (e) {
      e;
    }
  }

  Future<void> fetchMessages(int contactId) async {
    if (_userID == null) return;

    try {
      _messages = await _apiService.getMessages(_userID!, contactId);
      notifyListeners();
    } catch (e) {
      e;
    }
  }

  Future<void> sendMessage(int receiverId, String content) async {
    if (_userID == null) return;

    try {
      final message = await _apiService.sendMessage(
        _userID!,
        receiverId,
        content,
      );

      _messages.add(message); // 🔥 ajout immédiat
      notifyListeners();
    } catch (e) {
      print("Erreur envoi message : $e");
    }
  }

  Future<bool> existe(String phone) async {
    return _apiService.userExiste(phone);
  }

  Future<int> getID(String userphone) async {
    return _apiService.userID(userphone);
  }
}
