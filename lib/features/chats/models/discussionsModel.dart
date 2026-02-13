class Discussion {
  final int contactId;
  final String phone;
  final String username;
  final String lastMessage;
  final DateTime lastMessageTime;

  Discussion({
    required this.contactId,
    required this.phone,
    required this.username,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      contactId: json['contact_id'] ?? 0,
      phone: json['phone'] ?? '',
      username: json['username'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: DateTime.parse(json['last_message_time']),
    );
  }
}
