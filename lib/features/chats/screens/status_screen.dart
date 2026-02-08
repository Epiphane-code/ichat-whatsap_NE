import 'package:flutter/material.dart';
import 'package:ichat/features/chats/db/personDB.dart';
import 'package:ichat/features/chats/widgets/status_tile.dart';
import 'package:ichat/l10n/app_localizations.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final pers = contacts;
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
            AppLocalizations.of(context)!.status,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container( decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pers.length,
            itemBuilder: (context, index) {
              final perso = pers[index];
              return Row(
                children: [
                  statusTile(context, perso),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        ),
         Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Chaines et info',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pers.length,
            itemBuilder: (context, indext) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(pers[indext].avatarUrl, width: 120, height: 200, fit: BoxFit.cover,),
                  title: Text('Chaine Television'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Info JDR'),
                      Text('Haoussa')
                    ],
                  ),
                  trailing: Text('aujourd\'hui'),
                ),
              );
          }),
        )
      ],
    );
  }
}
