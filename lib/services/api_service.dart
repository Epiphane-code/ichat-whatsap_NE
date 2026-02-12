import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ichat/features/chats/models/discussionsModel.dart';
import 'package:ichat/features/chats/models/users.dart';
import 'package:ichat/features/chats/models/contact_model.dart';
import 'package:ichat/features/chats/models/messageModel.dart';


class ApiService {
  static const String _baseUrl = 'http://10.255.84.125:8000';

 Future<int?> login(String phone) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/users/exists/$phone'),
    headers: {'Content-Type': 'application/json'},
  );

  print('Réponse brute : ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['exists'] == true) {
      return data['user_id'];
    }
    return null;
  } else {
    throw Exception('Erreur serveur');
  }
}


  Future<Contact> createContact(int ownerId, String name, String phone) async {
    final url = Uri.parse('$_baseUrl/contacts/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "owner_id": ownerId,
        "name": name,
        "phone": phone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Contact.fromJson(data);
    } else {
      throw Exception('Erreur création contact : ${response.body}');
    }
  }


   // Récupérer les contacts d'un utilisateur
  Future<List<Contact>> getMyContacts(int ownerId) async {
    final url = Uri.parse('$_baseUrl/contacts/liste/$ownerId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Erreur récupération contacts : ${response.body}');
    }
  }



  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception(
        'Un probleme est survenu lors de la récupération des utilisateurs',
      );
    }
  }

  Future<void> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/otp/send_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // ignore: avoid_print
      print(data['code']);
    } else {
      throw Exception('Erreur serveur : ${response.statusCode}');
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/otp/verify_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] == true;
    } else {
      throw Exception('Erreur serveur : ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchToken(String phone) async {
    final uri = Uri.parse('$_baseUrl/token/infouser');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Réponse API fetchToken : $data'); // debug
      return data;
    } else {
      throw Exception('Erreur serveur : ${response.statusCode}');
    }
  }

  Future<List<Discussion>> getMyDiscussions(int userId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/messages/discussions/$userId'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);

    return data.map((e) => Discussion.fromJson(e)).toList();
  } else {
    throw Exception("Erreur récupération discussions");
  }
}


Future<List<Message>> getMessages(int userId, int contactId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/messages/messages/$userId/$contactId'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => Message.fromJson(e)).toList();
  } else {
    throw Exception("Erreur récupération messages");
  }
}

Future<Message> sendMessage(
    int senderId,
    int receiverId,
    String content,
) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/messages/send'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Message.fromJson(data);
  } else {
    throw Exception('Erreur envoi message');
  }
}




}
