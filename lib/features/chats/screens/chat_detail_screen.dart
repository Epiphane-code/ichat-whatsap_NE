import 'package:flutter/material.dart';
import 'package:ichat/features/chats/models/discussionsModel.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}
class _ChatDetailScreenState extends State<ChatDetailScreen> {

  late Discussion contact;
  final TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    contact = ModalRoute.of(context)!.settings.arguments as Discussion;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth.fetchMessages(contact.contactId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: const CircleAvatar(
            radius: 13,
            child: Icon(Icons.person, size: 20),
          ),
          title: Text(
            contact.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Column(
        children: [

          /// LISTE DES MESSAGES
          Expanded(
            child: ListView.builder(
              itemCount: auth.messages.length,
              itemBuilder: (context, index) {
                final message = auth.messages[index];

                final isMe = message.senderId == auth.userID;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blue.shade300
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message.content),
                  ),
                );
              },
            ),
          ),


          

          /// CHAMP ENVOI MESSAGE
          _buildMessageInput(context, auth),

          SizedBox(height: 10,)
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
            if (controller.text.trim().isEmpty) return;

            await auth.sendMessage(
              contact.contactId,
              controller.text.trim(),
            );

            controller.clear();
          },
        )
      ],
    ),
  );
}

}
