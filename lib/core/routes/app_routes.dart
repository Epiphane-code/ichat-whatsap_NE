import 'package:flutter/material.dart';
import '../../features/ai_chat/screens/ai_chat_screen.dart';
import '../../features/chats/screens/chat_detail_screen.dart';
import '../../features/new_chat/new_chat_screen.dart';
import '../../features/chats/screens/status_screen.dart';
import '../../features/chats/screens/calls_screen.dart';
import '../../features/chats/screens/home.dart';
import '../../features/chats/screens/login.dart';


class AppRoutes {
  static const home = '/home';
  static const chatDetail = '/chat_detail';
  static const newChat = '/new_chat';
  static const aiChat = '/ai_chat';
  static const status = '/status';
  static const calls = '/calls';
  static const login = '/login';


  static Map<String, WidgetBuilder> routes = {
    home: (_) => HomeScreen(),
    chatDetail: (_) => ChatDetailScreen(),
    newChat: (_) => NewChatScreen(),
    aiChat: (_) => AIChatScreen(),
    status: (_) => StatusScreen(),
    calls: (_) => CallsScreen(),
    login: (_) => LoginScreen(),
  };
}
