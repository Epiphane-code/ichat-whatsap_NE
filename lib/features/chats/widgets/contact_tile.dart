import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class ContactTile extends StatelessWidget {
  final Person contact;
  final VoidCallback onTapMessage;
  final VoidCallback onTapCall;

  const ContactTile({super.key, required this.contact, required this.onTapMessage, required this.onTapCall});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: 26, child: Icon(Icons.person)),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        contact.phoneNumber,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.green),
            onPressed: onTapMessage,
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: onTapCall,
          ),
        ],
      ),
    );
  }
}
