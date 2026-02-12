import 'package:flutter/material.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/features/chats/models/discussionsModel.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({super.key});

  @override
  State<ContactsWidget> createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final auth = context.read<AuthProvider>();
    if (auth.userID != null) {
      setState(() {
        _isLoading = true;
      });
      await auth.fetchMyContacts();
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddContactDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Annuler')
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (result == true) {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      if (name.isNotEmpty && phone.isNotEmpty) {
        final auth = context.read<AuthProvider>();
        await auth.addContact(name, phone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes Contacts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddContactDialog,
              ),
            ],
          ),
        ),
        Expanded(
  child: Builder(
    builder: (context) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (auth.contacts.isEmpty || auth.discussionContacts.isEmpty) {
        return const Center(child: Text('Aucun contact trouvé'));
      }

      // Sécuriser la longueur pour éviter un index out of range
      final itemCount = auth.contacts.length < auth.discussionContacts.length
          ? auth.contacts.length
          : auth.discussionContacts.length;

      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final contact = auth.contacts[index];
          final info = auth.discussionContacts[index];

          return ListTile(
            leading: CircleAvatar (child: Icon(Icons.person)),
            title: Text(contact.username),
            subtitle: Text(contact.phone),
            trailing: const Text('Message'),
            onTap: () {
              // Naviguer après le build pour éviter rebuild loop
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, AppRoutes.chatDetail,
                    arguments: info);
              });
            },
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
