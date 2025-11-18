import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone_app/themes/theme_provider.dart';
import 'package:twitter_clone_app/components/my_settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: const Text('S E T T I N G S'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //body
      body: Column(
        children: [
          //Dark mode title
          MySettingsTile(
            title: "D A R K   M O D E",
            action: CupertinoSwitch(
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              value: Provider.of<ThemeProvider>(context).isDarkMode,
            ),
          ),
          //Block users title

          //Account setting Title
        ]),
    );
  }
}