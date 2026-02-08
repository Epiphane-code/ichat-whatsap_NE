import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ichat/features/chats/models/users.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  Future<bool> login(String phone) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/users/exists/$phone'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['exists'] == true;
  } else {
    throw Exception('Erreur serveur : ${response.statusCode}');
  }
}


  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Un probleme est survenu lors de la récupération des utilisateurs');
    }
  }
}