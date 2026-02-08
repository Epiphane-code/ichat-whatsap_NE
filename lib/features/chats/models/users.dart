class User {
  final String id;
  final String username;
  final String phone;
  final String password;
  final String avatarUrl;

  User({
    required this.id,
    required this.username,
    required this.phone,
    required this.password,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      password: json['password'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
