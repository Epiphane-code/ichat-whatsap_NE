import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _initialized = false;

  int contactId = 0;
  late String username;
  late String phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      username = args['username'];
      phone = args['phone'];

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final auth = context.read<AuthProvider>();

        /// 🔍 Récupérer ID du user via phone
        final id = await auth.getID(phone.trim());
        if (!mounted) return;

        if (id == 0) {
          setState(() {
            contactId = 0;
            _isLoading = false;
          });
          return;
        }

        contactId = id;

        await auth.fetchMessages(contactId);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent,); // 🔥 reste en bas
          }
        });

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            radius: 13,
            child: Icon(Icons.person, size: 20),
          ),
          title: Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(phone),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// 📜 LISTE DES MESSAGES
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: auth.messages.length,
                    itemBuilder: (context, index) {
                      final message = auth.messages[index];
                      final isMe = message.senderId == auth.userID;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color.fromARGB(255, 161, 211, 138)
                                : const Color.fromARGB(255, 203, 245, 229),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                             constraints: BoxConstraints(
                              minWidth: 50,
                              maxWidth: 250   // largeur minimale si vous voulez
                             ),
                            child: Text(message.content)
                            ),
                        ),
                      );
                    },
                  ),
                ),

                /// ✉️ INPUT MESSAGE
                _buildMessageInput(context, auth),

                const SizedBox(height: 10),
              ],
            ),
    );
  }

  Widget _buildMessageInput(BuildContext context, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Votre message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              await auth.sendMessage(contactId, text);
              controller.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
