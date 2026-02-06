import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language_code');

    if (savedLang != null) {
      _locale = Locale(savedLang);
    } else {
      final systemLang = PlatformDispatcher.instance.locale.languageCode;
      const supported = ['fr', 'en', 'ha', 'dje', 'ff', 'taq', 'kr', 'ar'];

      if (!supported.contains(systemLang)) {
        _locale = const Locale('fr');
        notifyListeners();
        return;
      }

      _locale = Locale(systemLang);
    }

    notifyListeners();
  }

  Future<void> changeLanguage(String code) async {
    _locale = Locale(code);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
  }
}
