import 'package:flutter/material.dart';
import 'package:ichat/features/chats/models/chat_model.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactName =
        ModalRoute.of(context)!.settings.arguments as Chat;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(radius: 13, child: Icon(Icons.person, size: 20)),
          title: Text(
            contactName.name,
            maxLines: 1, // Limite à une seule ligne
  overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text("Conversation ici"),
      ),
    );
  }
}
