import 'package:flutter/material.dart';
import 'package:ichat/core/routes/app_routes.dart';
import '../models/contact_model.dart';
import '../models/chat_model.dart';
import '../widgets/contact_tile.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Person> contacts = [
      Person(
        name: 'Omar',
        phoneNumber: '1234567890',
        avatarUrl: 'assets/images_profile/p1.jpg',
      ),
      Person(
        name: 'Issa Boukari',
        phoneNumber: '0987654321',
        avatarUrl: 'assets/images_profile/p2.jpg',
      ),
      Person(
        name: 'Rachid Idi',
        phoneNumber: '1122334455',
        avatarUrl: 'assets/images_profile/p3.jpg',
      ),
      Person(
        name: 'Ousmane Diallo',
        phoneNumber: '5544332211',
        avatarUrl: 'assets/images_profile/p4.jpg',
      ),
      Person(
        name: 'Djamilou boucar',
        phoneNumber: '9988776655',
        avatarUrl: 'assets/images_profile/p5.jpg',
      ),
      Person(
        name: 'Papa',
        phoneNumber: '6677889900',
        avatarUrl: 'assets/images_profile/p6.jpg',
      ),
      Person(
        name: 'Karima',
        phoneNumber: '4433221100',
        avatarUrl: 'assets/images_profile/p7.jpg',
      ),
      Person(
        name: 'Myriam',
        phoneNumber: '2211003344',
        avatarUrl: 'assets/images_profile/p8.jpg',
      ),
      Person(
        name: 'Soumaila Abdou',
        phoneNumber: '7766554433',
        avatarUrl: 'assets/images_profile/p9.jpg',
      ),
      Person(
        name: 'Adamou Moumouni',
        phoneNumber: '3344556677',
        avatarUrl: 'assets/images_profile/p10.jpg',
      ),
      Person(
        name: 'Kaka',
        phoneNumber: '1122334455',
        avatarUrl: 'assets/images_profile/p11.jpg',
      ),
      Person(
        name: 'Song',
        phoneNumber: '1234567890',
        avatarUrl: 'assets/images_profile/p12.jpg',
      ),
      Person(
        name: 'Seydou',
        phoneNumber: '0987654321',
        avatarUrl: 'assets/images_profile/p13.jpg',
      ),
      Person(
        name: 'Aminata',
        phoneNumber: '5544332211',
        avatarUrl: 'assets/images_profile/p15.jpg',
      ),
    ];
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
          child: const Text(
            'Contacts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
