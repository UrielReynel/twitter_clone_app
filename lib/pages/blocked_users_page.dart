import 'package:flutter/material.dart';
import '../services/database/database_service.dart';

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
        stream: databaseService.getBlockedUidsStream(), // Escuchar cambios
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
               
               // Aquí deberíamos cargar los datos del usuario bloqueado
               // Por simplicidad, mostramos un tile genérico con opción a desbloquear
               return ListTile(
                 title: Text(userId), // Idealmente mostrar nombre
                 subtitle: const Text("Usuario bloqueado"),
                 trailing: IconButton(
                   icon: const Icon(Icons.lock_open),
                   onPressed: () async {
                      // Desbloquear
                      await databaseService.unblockUser(userId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Usuario desbloqueado"))
                        );
                      }
                   },
                 ),
               );
             },
           );
        },
      ),
    );
  }
}