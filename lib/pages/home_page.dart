/*
  UBICACIÓN: lib/pages/home_page.dart
*/

import 'package:flutter/material.dart';
import '../components/my_drawer.dart';
import '../components/my_input_alert_box.dart';
import '../components/my_post_tile.dart';
import '../models/post.dart';
import '../services/database/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Servicio de base de datos
  final _database = DatabaseService();
  
  // Controlador para escribir nuevo tweet
  final _newPostController = TextEditingController();

  // Función para abrir la caja de texto y publicar
  void _openPostMessageBox() {
    showDialog(
      context: context, 
      builder: (context) => MyInputAlertBox(
        textController: _newPostController, 
        hintText: "¿Qué estás pensando?", 
        onPressed: () async {
          // Publicar en Firebase
          await _database.postMessageInFirebase(_newPostController.text);
        }, 
        onPressedText: "Publicar"
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(), // Aquí usamos el Drawer que ya creaste
      appBar: AppBar(
        title: const Text("I N I C I O"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      // Botón Flotante para Twittear
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: const Icon(Icons.add),
      ),
      
      // Lista de Posts (Escuchamos el Stream de la base de datos)
      body: StreamBuilder<List<Post>>(
        stream: _database.getAllPosts(),
        builder: (context, snapshot) {
          // 1. Cargando...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error
          if (snapshot.hasError) {
            return const Center(child: Text("Algo salió mal..."));
          }

          // 3. No hay datos
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay publicaciones aún."));
          }

          // 4. Mostrar lista
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return MyPostTile(post: post);
            },
          );
        },
      ),
    );
  }
}