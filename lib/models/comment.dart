/*
  UBICACIÓN: lib/models/comment.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;        // ID del comentario
  final String postId;    // ID del post al que pertenece
  final String uid;       // Quién comentó
  final String name;      // Nombre del que comentó
  final String username;  // Usuario del que comentó
  final String message;   // Texto del comentario
  final Timestamp timestamp; // Cuándo comentó

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  // Convertir documento de Firestore a objeto Comment
  factory Comment.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Comment(
      id: doc.id,
      postId: data['postId'],
      uid: data['uid'],
      name: data['name'],
      username: data['username'],
      message: data['message'],
      timestamp: data['timestamp'],
    );
  }

  // Convertir objeto Comment a Mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
    };
  }
}