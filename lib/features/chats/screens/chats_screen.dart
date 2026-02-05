import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../models/chat_model.dart';
import '../widgets/chat_tile.dart';
import '../../../core/routes/app_routes.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faker = Faker();
    final photos  = [
      'assets/images_profile/p1.jpg',
      'assets/images_profile/p2.jpg',
      'assets/images_profile/p3.jpg',
      'assets/images_profile/p4.jpg',
      'assets/images_profile/p5.jpg',
      'assets/images_profile/p6.jpg',
      'assets/images_profile/p7.jpg',
      'assets/images_profile/p8.jpg',
      'assets/images_profile/p9.jpg',
      'assets/images_profile/p10.jpg',
    ];
    final noms = [
      'Omar',
      'Issa Boukari',
      'Rachid Idi',
      'Ousmane Diallo',
      'Djamilou boucar',
      'Papa',
      'Karima',
      'Myriam',
      'Soumaila Abdou',
      'Adamou Moumouni',
      'Fatoumata',
      'Amina',
      'Yacouba',
      'Salifou',
      'Hassan',
      'Boubey',
      'Khadija',
      'Laila',
      'Nadia',
      'Saidatou',
    ];

    final chats = List.generate(
      20,
      (_) => Chat(
        name: noms[faker.randomGenerator.integer(noms.length - 1)],
        message: faker.lorem.sentence(),
        time:
            '${faker.randomGenerator.integer(12)}:${faker.randomGenerator.integer(59)}',
        unreadCount: faker.randomGenerator.integer(3),
        avatarUrl: photos[faker.randomGenerator.integer(photos.length - 1)],

      ),
    );
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
                  'WhatsApp NE',
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
