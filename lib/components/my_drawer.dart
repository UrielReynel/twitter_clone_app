import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart'; // Asegúrate de tener este servicio
import '../pages/settings_page.dart'; // Y la página de configuración
import '../pages/profile_page.dart';  // Y la página de perfil
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthService();

  // Función para cerrar sesión
  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // 1. Logo en la cabecera
          DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 25),

          // 2. Opción INICIO
          MyDrawerTile(
            title: "I N I C I O",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
            },
          ),

          // 3. Opción PERFIL (Te dirigirá a la profile_page que creaste vacía)
          MyDrawerTile(
            title: "P E R F I L",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  // IMPORTANTE: Aquí usaremos el uid actual, por ahora lo dejamos así
                  builder: (context) => ProfilePage(uid: _auth.getCurrentUid()),
                ),
              );
            },
          ),

           // 4. Opción BÚSQUEDA (Agregaremos esto más adelante en search_page)
           /*
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
          */

          // 5. Opción CONFIGURACIÓN
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

          const Spacer(), // Empuja todo lo siguiente hacia abajo

          // 6. Opción SALIR
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