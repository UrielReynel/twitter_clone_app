import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  SETTINGS TILE

  A simple tile for settings page
  - title: name of settings
  - action: the action widget (usually a switch)
*/

class MySettingsTile extends StatelessWidget {
  final String title;
  final Widget action;

  const MySettingsTile({
    super.key,
    required this.title,
    required this.action,
  });
  
  //Build UI
  @override
  Widget build(BuildContext context) {
    //Container
    return Container(
      //Styling
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12)
      ),
      
      //Margin
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      
      //Padding
      padding: const EdgeInsets.all(25),
      
      //Content: Title and action
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Title
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          //Action widget
          action,
        ],
      ),
    );
  }
}