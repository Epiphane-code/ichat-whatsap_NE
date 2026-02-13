import 'package:flutter/material.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({super.key});

  @override
  State<ContactsWidget> createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  bool _isLoading = true;

  /// 🔐 Cache pour éviter d’appeler l’API à chaque build
  final Map<String, bool> _existenceCache = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  Future<void> _loadContacts() async {
    final auth = context.read<AuthProvider>();

    if (auth.userID != null) {
      setState(() => _isLoading = true);

      await auth.fetchMyContacts();
      await auth.fetchDiscussions();

      /// 🔐 Pré-charger la vérification des numéros
      for (var contact in auth.contacts) {
        final exists = await auth.existe(contact.phone);
        _existenceCache[contact.phone] = exists;
      }

      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddContactDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    final result = await showDialog<bool>(
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
            child: const Text('Annuler'),
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
        await _loadContacts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        /// 🔝 Header
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes Contacts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddContactDialog,
              ),
            ],
          ),
        ),

        /// 📋 Liste des contacts
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : auth.contacts.isEmpty
                  ? const Center(child: Text('Aucun contact trouvé'))
                  : ListView.builder(
                      itemCount: auth.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = auth.contacts[index];

                        /// 🔐 Récupérer l’état depuis le cache
                        final existe =
                            _existenceCache[contact.phone] ?? false;

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(contact.username),
                          subtitle: Text(contact.phone),

                          /// 📌 Indicateur visuel si le contact est sur iChat
                          trailing: existe
                              ? const Icon(Icons.message, color: Colors.green)
                              : const Icon(Icons.person_add_alt_1,
                                  color: Colors.grey),

                          onTap: existe
                              ? () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chatDetail,
                                    arguments: {
                                      'username': contact.username,
                                      'phone': contact.phone,
                                    },
                                  );
                                }
                              : () {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Ce numéro n'est pas sur iChat"),
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
