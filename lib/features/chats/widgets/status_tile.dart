import 'package:flutter/material.dart';
import 'package:ichat/features/chats/models/contact_model.dart';



Widget statusTile(BuildContext context,Person arguments){
  return SizedBox(
    width: 80,
    height: 100,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Image.asset(arguments.avatarUrl,
      fit: BoxFit.cover,),
    ),
  );

}