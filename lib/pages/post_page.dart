/*
  UBICACIÓN: lib/pages/post_page.dart
*/
import 'package:flutter/material.dart';
import '../components/my_comment_tile.dart';
import '../components/my_post_tile.dart';
import '../models/post.dart';
import '../services/database/database_service.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _database = DatabaseService();
  final _commentController = TextEditingController();

  // Función para comentar
  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      _database.addComment(widget.post.id, _commentController.text);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Comentarios"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // 1. El Post Original (Usamos el tile que ya tienes)
          MyPostTile(post: widget.post),

          const SizedBox(height: 10),

          // 2. Lista de Comentarios
          Expanded(
            child: StreamBuilder(
              stream: _database.getComments(widget.post.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final comments = snapshot.data!;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return MyCommentTile(comment: comment);
                  },
                );
              },
            ),
          ),

          // 3. Input para escribir comentario
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Escribe una respuesta...",
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}