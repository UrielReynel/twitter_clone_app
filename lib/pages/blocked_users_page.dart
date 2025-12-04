import 'package:flutter/material.dart';
import '../services/database/database_service.dart';
import '../models/user.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios Bloqueados"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<List<String>>(
        stream: databaseService.getBlockedUidsStream(),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           }

           if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No tienes usuarios bloqueados."));
           }

           final blockedUids = snapshot.data!;

           return ListView.builder(
             itemCount: blockedUids.length,
             itemBuilder: (context, index) {
               final userId = blockedUids[index];
               
               // Cargar datos del usuario bloqueado
               return FutureBuilder<UserProfile?>(
                 future: databaseService.getUserFromFirebase(userId),
                 builder: (context, userSnapshot) {
                   if (userSnapshot.connectionState == ConnectionState.waiting) {
                     return const ListTile(
                       title: Text("Cargando..."),
                       leading: CircularProgressIndicator(),
                     );
                   }

                   final user = userSnapshot.data;
                   
                   return ListTile(
                     leading: Icon(
                       Icons.person,
                       color: Theme.of(context).colorScheme.primary,
                     ),
                     title: Text(user?.name ?? "Usuario desconocido"),
                     subtitle: Text("@${user?.username ?? "usuario"}"),
                     trailing: IconButton(
                       icon: const Icon(Icons.lock_open),
                       tooltip: "Desbloquear usuario",
                       onPressed: () async {
                          await databaseService.unblockUser(userId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${user?.username ?? "Usuario"} desbloqueado")
                              ),
                            );
                          }
                       },
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