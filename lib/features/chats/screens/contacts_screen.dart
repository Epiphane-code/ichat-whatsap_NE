import 'package:flutter/material.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/features/chats/models/chat_model.dart';
import 'package:ichat/features/chats/widgets/contact_tile.dart';
import 'package:ichat/l10n/app_localizations.dart';
import 'package:ichat/features/chats/db/personDB.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.contacts,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contactIndex = contacts[index];
              // ignore: unused_local_variable
              final Chat contactArg = Chat(
                name: contactIndex.name,
                message: '',
                time: '',
                unreadCount: 0,
                avatarUrl: '',
              );

              return ContactTile(
                contact: contactIndex,
                onTapMessage: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatDetail,
                    arguments: Chat(
                      name: contactIndex.name,
                      message: '',
                      time: '',
                      unreadCount: 0,
                      avatarUrl: contactIndex.avatarUrl,
                    ),
                  );
                },
                onTapCall: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.calls,
                    arguments: contacts[index],
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
