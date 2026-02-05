import 'package:flutter/material.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouveau chat")),
      body: const Center(
        child: Text("Créer un nouveau chat"),
      ),
    );
  }
}
