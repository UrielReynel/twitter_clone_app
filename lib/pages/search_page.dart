import 'package:flutter/material.dart';
import '../services/database/database_service.dart';
import '../models/user.dart';
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Buscar usuarios...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Reconstruir la vista cuando se escribe (para buscar en tiempo real)
            setState(() {});
          },
        ),
      ),
      body: _searchController.text.isEmpty
          ? Center(
              child: Text(
                "Escribe un nombre para buscar.",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            )
          : FutureBuilder<List<UserProfile>>(
              future: _databaseService.searchUsers(_searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al buscar."));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No se encontraron usuarios."));
                }

                final users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text('@${user.username}'),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                      ),
                      onTap: () {
                        // Ir al perfil del usuario
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