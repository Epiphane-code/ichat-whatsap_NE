
class Person {
  final String name;
  final String phoneNumber;
  final String avatarUrl;
  final bool isAuthenticated = false;
  final bool isOnline = false;

  Person({
    required this.name,
    required this.phoneNumber,
    required this.avatarUrl,
  });
}
class Contact {
  final int id;
  final String username;
  final String phone;

  Contact({required this.id, required this.username, required this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "phone": phone,
    };
  }
}
