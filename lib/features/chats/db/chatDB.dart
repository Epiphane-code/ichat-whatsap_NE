import 'package:ichat/features/chats/models/chat_model.dart';
import 'package:faker/faker.dart';
import 'package:ichat/features/chats/db/personDB.dart';

final chats = List.generate(
      20,
      (_) => Chat(
        name: contacts[faker.randomGenerator.integer(contacts.length - 1)].name,
        message: faker.lorem.sentence(),
        time:
            '${faker.randomGenerator.integer(12)}:${faker.randomGenerator.integer(59)}',
        unreadCount: faker.randomGenerator.integer(3),
        avatarUrl: contacts[faker.randomGenerator.integer(contacts.length - 1)].avatarUrl,

      ),
    );