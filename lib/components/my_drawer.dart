/*
  UBICACIÓN: lib/components/my_drawer.dart
  ESTADO: COMPLETO (Agregada la navegación a SearchPage)
*/

import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../pages/settings_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart'; // <--- IMPORTAR ESTO
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthService();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Logo
          DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 25),

          // INICIO
          MyDrawerTile(
            title: "I N I C I O",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // PERFIL
          MyDrawerTile(
            title: "P E R F I L",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(uid: _auth.getCurrentUid()),
                ),
              );
            },
          ),

          // BUSCAR (AÑADIDO)
          MyDrawerTile(
            title: "B U S C A R",
            icon: Icons.search,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SearchPage())
              );
            },
          ),

          // AJUSTES
          MyDrawerTile(
            title: "A J U S T E S",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),

          const Spacer(),

          // SALIR
          MyDrawerTile(
            title: "S A L I R",
            icon: Icons.logout,
            onTap: logout,
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}