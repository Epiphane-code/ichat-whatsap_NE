import 'package:flutter/material.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/features/chats/models/contact_model.dart';
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
        auth.fetchMyContacts();
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
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Chats",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    final discussion = auth.discussionContacts[index];
                    String username = discussion.phone;
                    String phone = discussion.phone;
                    for (var cont in auth.contacts) {
                      if (cont.phone == discussion.phone) {
                        username = cont.username;
                        break;
                      }
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                        ),
                      ),
                      title: Text(username),
                      subtitle: Text(discussion.lastMessage),
                      trailing: Text(
                        '${discussion.lastMessageTime.hour} : ${discussion.lastMessageTime.minute}',
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatDetail,
                          arguments: {'username': username, 'phone': phone},
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
