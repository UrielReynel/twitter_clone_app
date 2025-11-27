import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_settings_tile.dart';
import '../themes/theme_provider.dart';
import 'blocked_users_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("A J U S T E S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Switch Modo Oscuro
          MySettingsTile(
            title: "Modo Oscuro",
            action: Switch(
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),

          // Botón Usuarios Bloqueados
          MySettingsTile(
            title: "Usuarios Bloqueados",
            action: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const BlockedUsersPage())
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}