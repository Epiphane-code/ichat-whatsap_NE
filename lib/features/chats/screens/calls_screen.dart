import 'package:flutter/material.dart';
import 'package:ichat/l10n/app_localizations.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}
class _CallsScreenState extends State<CallsScreen> {

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            AppLocalizations.of(context)!.calls,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
         const SizedBox(height: 16),
          Center(
            child: Text(
            AppLocalizations.of(context)!.calls,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),)
      ],
    );
  }
}