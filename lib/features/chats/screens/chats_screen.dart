import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:ichat/features/chats/models/chat_model.dart';
import 'package:ichat/features/chats/widgets/chat_tile.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/features/chats/db/chatDB.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'i-Chat',
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
        Expanded(
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatTile(
                  chat: chats[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatDetail,
                      arguments: Chat(
                        name: chats[index].name,
                        message: chats[index].message,
                        time: chats[index].time,
                        unreadCount: chats[index].unreadCount,
                        avatarUrl: chats[index].avatarUrl,
                      ),
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
