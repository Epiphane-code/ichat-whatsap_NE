import 'package:flutter/material.dart';
import 'package:ichat/features/chats/screens/contacts_screen.dart';
import 'package:ichat/core/routes/app_routes.dart';
import 'package:ichat/l10n/app_localizations.dart';
import 'package:ichat/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'chats_screen.dart';
import 'status_screen.dart';
import 'calls_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [ChatsScreen(), ContactsWidget(), StatusScreen(), CallsScreen()];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (!auth.isLogin){
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(child: _screens[_currentIndex]),
      floatingActionButton: FloatingActionButton(
        heroTag: "ai_chat",
        child: const Icon(Icons.smart_toy),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.aiChat);
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: AppLocalizations.of(context)!.chats),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: AppLocalizations.of(context)!.contacts),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt),label: AppLocalizations.of(context)!.status,),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: AppLocalizations.of(context)!.calls),
        ],
      ),
    );
  }
}
