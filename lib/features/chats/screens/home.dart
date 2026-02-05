import 'package:flutter/material.dart';
import 'package:ichat/features/chats/screens/contacts_screen.dart';
import '../../../core/routes/app_routes.dart';

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
    _screens = [ChatsScreen(), ContactsScreen(), StatusScreen(), CallsScreen()];
  }

  @override
  Widget build(BuildContext context) {
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

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt),label: 'Status',),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Appels'),
        ],
      ),
    );
  }
}
