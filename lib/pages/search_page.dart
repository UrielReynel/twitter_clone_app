/*
  UBICACIÓN: lib/pages/search_page.dart
  ESTADO: COMPLETO (Busca usuarios por nombre y redirige al perfil)
*/

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database/database_service.dart';
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // La barra de búsqueda va dentro del título del AppBar
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          decoration: InputDecoration(
            hintText: "Buscar usuarios...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),
          // Actualizar estado cada vez que se escribe una letra
          onChanged: (value) => setState(() {}),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _searchController.text.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Busca personas para seguir",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<UserProfile>>(
              // Llamamos a la función de búsqueda de la base de datos
              future: _databaseService.searchUsers(_searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error al buscar"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No se encontraron usuarios"));
                }

                final users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    
                    // Diseño del resultado de búsqueda (Tile)
                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.person),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      subtitle: Text(
                        "@${user.username}",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      onTap: () {
                        // Ir al perfil del usuario encontrado
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: user.uid),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}