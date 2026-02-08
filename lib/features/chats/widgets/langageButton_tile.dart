import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ichat/providers/langage_provider.dart';

Widget languageButton(BuildContext context, String code, String name) {
  return ListTile(
    title: Text(name),
    onTap: () {
      final lang = context.read<LanguageProvider>();
      lang.changeLanguage(code);
      Navigator.pop(context);
    },
  );
}
