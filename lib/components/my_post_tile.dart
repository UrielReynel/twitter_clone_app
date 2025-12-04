/*
  UBICACIÓN: lib/components/my_post_tile.dart
  ESTADO: COMPLETO (Incluye Likes, Navegación, Menú de Reporte/Bloqueo/Borrado)
*/

import 'package:flutter/material.dart';
import '../components/like_button.dart';
import '../models/post.dart';
import '../services/database/database_service.dart';
import '../pages/post_page.dart';
import '../pages/profile_page.dart';
import '../services/auth/auth_service.dart';

class MyPostTile extends StatefulWidget {
  final Post post;

  const MyPostTile({
    super.key,
    required this.post,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late bool isLiked; 
  final _databaseService = DatabaseService();
  final _authService = AuthService(); // Para saber quién soy

  @override
  void initState() {
    super.initState();
    _checkIsLiked();
  }

  void _checkIsLiked() {
    final currentUid = _authService.getCurrentUid();
    isLiked = widget.post.likes.contains(currentUid);
    setState(() {});
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    _databaseService.toggleLike(widget.post.id);
  }

  // --- NUEVAS FUNCIONES DE MODERACIÓN ---

  // Mostrar opciones (Borrar o Reportar/Bloquear)
  void showOptions() {
    String currentUid = _authService.getCurrentUid();
    bool isOwnPost = widget.post.uid == currentUid;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Opción: Borrar (Solo si es MÍO)
              if (isOwnPost)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Borrar publicación"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _databaseService.deletePost(widget.post.id);
                  },
                )
              else ...[
                // Opción: Reportar (Si es de OTRO)
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Reportar publicación"),
                  onTap: () {
                    Navigator.pop(context);
                    _reportPost();
                  },
                ),
                // Opción: Bloquear (Si es de OTRO)
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Bloquear usuario"),
                  onTap: () {
                    Navigator.pop(context);
                    _blockUser();
                  },
                ),
              ],
              
              // Opción: Cancelar (Para todos)
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancelar"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _reportPost() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Reportar"),
        content: const Text("¿Deseas reportar este contenido ofensivo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar")
          ),
          TextButton(
            onPressed: () async {
              await _databaseService.reportUser(widget.post.id, widget.post.uid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Reporte enviado. Gracias."))
              );
            }, 
            child: const Text("Reportar")
          ),
        ],
      )
    );
  }

  void _blockUser() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Bloquear"),
        content: const Text("¿Deseas bloquear a este usuario? No verás más sus publicaciones."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar")
          ),
          TextButton(
            onPressed: () async {
              await _databaseService.blockUser(widget.post.uid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Usuario bloqueado."))
              );
              // Opcional: Recargar para ocultar posts inmediatamente
            }, 
            child: const Text("Bloquear")
          ),
        ],
      )
    );
  }

  // --------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => PostPage(post: widget.post))
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Usuario y botón de opciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Perfil Clickable
                GestureDetector(
                  onTap: () {
                     Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ProfilePage(uid: widget.post.uid))
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          Text(
                            '@${widget.post.username}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Botón de 3 puntos (Opciones)
                IconButton(
                  onPressed: showOptions, 
                  icon: Icon(
                    Icons.more_horiz, 
                    color: Theme.of(context).colorScheme.primary
                  )
                ),
              ],
            ),
  
            const SizedBox(height: 20),
  
            // Mensaje
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
  
            const SizedBox(height: 20),
  
            // Botones de Acción (Like y Responder)
            Row(
              children: [
                LikeButton(isLiked: isLiked, onTap: toggleLike),
                const SizedBox(width: 5),
                Text(
                   widget.post.likes.length.toString(),
                   style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                
                const Spacer(),
                
                Icon(Icons.comment, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 5),
                Text("Responder", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}