import 'package:flutter/material.dart';
import '../models/comment.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;

  const MyCommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary, // Un color un poco distinto
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Autor y Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " . ", // Aquí luego pondremos la fecha formateada
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          
          const SizedBox(height: 5),

          // Texto del comentario
          Text(comment.message),
        ],
      ),
    );
  }
}