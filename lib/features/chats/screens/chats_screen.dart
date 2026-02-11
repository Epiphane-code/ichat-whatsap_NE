import 'package:flutter/material.dart';
import 'package:ichat/features/chats/models/chat_model.dart';
import 'package:ichat/features/chats/widgets/chat_tile.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.userID != null) {
        auth.fetchDiscussions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Container()),
                Icon(Icons.photo_camera, color: Colors.grey.shade700),
                SizedBox(width: 20),
                Icon(Icons.menu, color: Colors.grey.shade700),
              ],
            ),
          ),
        ),

        /// 🔥 Liste des discussions dynamiques
        Expanded(
          child: auth.discussionContacts.isEmpty
              ? Center(child: Text("Aucune discussion"))
              : ListView.builder(
                  itemCount: auth.discussionContacts.length,
                  itemBuilder: (context, index) {
                    final contactId = auth.discussionContacts[index];

                    return ListTile(
                      leading: Text('icon'),
                      title: Text("Discussion avec ID $contactId"),
                      subtitle: Text('message'),
                      trailing: Text('right'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatDetail,
                          arguments: contactId,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
