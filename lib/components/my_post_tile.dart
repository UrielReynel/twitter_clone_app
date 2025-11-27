import 'package:flutter/material.dart';
import '../components/like_button.dart';
import '../models/post.dart';
import '../services/database/database_service.dart';

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
  // Variable local para controlar el estado del like
  late bool isLiked; // Usamos 'late' porque la iniciaremos en initState

  // Instancia de base de datos
  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _checkIsLiked();
  }

  // Verificar si el usuario actual ya dio like a este post
  void _checkIsLiked() async {
    // Nota: Esto se mejorará más adelante con la lógica real de Auth
    // Por ahora asumimos estado inicial basado en la lista de likes del post
    // Necesitaremos el UID del usuario actual aquí más adelante
    setState(() {
       // Lógica temporal hasta tener el AuthProvider conectado aquí
       isLiked = false; 
    });
  }

  // Función para dar/quitar like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    
    // Llamar a la base de datos
    _databaseService.toggleLike(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parte Superior: Icono Usuario + Nombre + Username
          Row(
            children: [
              // Icono de perfil
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.person),
              ),
              
              const SizedBox(width: 10),

              // Nombres
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

          const SizedBox(height: 20),

          // Contenido del Post
          Text(
            widget.post.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          const SizedBox(height: 20),

          // Botones de acción (Like y Comentar)
          Row(
            children: [
              // Botón de Like
              LikeButton(
                isLiked: isLiked,
                onTap: toggleLike,
              ),

              // Contador de Likes (Opcional, Mitch lo agrega después)
              const SizedBox(width: 5),
              Text(
                 widget.post.likes.length.toString(),
                 style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}