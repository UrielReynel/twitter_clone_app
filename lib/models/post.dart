/*
  UBICACIÓN: lib/models/post.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;        // ID del documento en Firebase
  final String uid;       // ID del usuario que publicó
  final String name;      // Nombre real
  final String username;  // Nombre de usuario (@ejemplo)
  final String message;   // El texto del tweet
  final Timestamp timestamp; // Fecha y hora
  final List<String> likes; // Lista de UIDs de personas que dieron like

  Post({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likes,
  });

  // Convertir documento de Firestore a objeto Post
  factory Post.fromDocument(DocumentSnapshot doc) {
    // Obtenemos los datos como un Mapa
    final data = doc.data() as Map<String, dynamic>;
    
    return Post(
      id: doc.id,
      uid: data['uid'],
      name: data['name'],
      username: data['username'],
      message: data['message'],
      timestamp: data['timestamp'],
      // Convertimos la lista dinámica a lista de Strings
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  // Convertir objeto Post a Mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likes': likes,
    };
  }
}