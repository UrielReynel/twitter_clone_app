/*
  UBICACIÓN: lib/services/database/database_service.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../../models/comment.dart';

class DatabaseService {
  // Instancias de Firebase
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
    ===========================================================================
    PERFILES DE USUARIO (User Profiles)
    ===========================================================================
  */

  // Guardar info de usuario nuevo al registrarse
  Future<void> saveUserInfoInFirebase({required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    // Creamos un username básico usando la parte anterior al @ del correo
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '', // Bio vacía al inicio
    );

    // Guardar en la colección 'Users'
    await _db.collection("Users").doc(uid).set(user.toMap());
  }

  // Obtener datos de un usuario por su UID
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocument(doc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Actualizar la Bio del usuario actual
  Future<void> updateBioInFirebase(String bio) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection("Users").doc(uid).update({'bio': bio});
  }

  // Buscar usuarios por nombre en la base de datos
  Future<List<UserProfile>> searchUsers(String searchTerm) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Users")
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      return snapshot.docs.map((doc) => UserProfile.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  /*
    ===========================================================================
    POSTS (Publicaciones)
    ===========================================================================
  */

  // Publicar un mensaje nuevo
  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      
      // Necesitamos los datos del usuario para poner su nombre en el post
      UserProfile? user = await getUserFromFirebase(uid);

      if (user != null) {
        Post newPost = Post(
          id: '', // Firebase generará el ID
          uid: uid,
          name: user.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          likes: [],
        );

        Map<String, dynamic> newPostMap = newPost.toMap();
        await _db.collection("Posts").add(newPostMap);
      }
    } catch (e) {
      print(e);
    }
  }

  // Obtener todos los posts (Stream para tiempo real)
  Stream<List<Post>> getAllPosts() {
    return _db
        .collection("Posts")
        .orderBy('timestamp', descending: true) // Los más nuevos primero
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  // Borrar post (Esta función se llama desde la UI si eres el dueño)
  Future<void> deletePost(String postId) async {
    await _db.collection("Posts").doc(postId).delete();
  }

  /*
    ===========================================================================
    LIKES
    ===========================================================================
  */

  // Dar o quitar Like a un post
  Future<void> toggleLike(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);
        
        // Obtener lista actual de likes
        List<String> likes = List<String>.from(postSnapshot['likes'] ?? []);

        // Lógica de toggle
        if (likes.contains(uid)) {
          likes.remove(uid); // Si ya estaba, lo quita
        } else {
          likes.add(uid); // Si no estaba, lo agrega
        }

        // Actualizar en BD
        transaction.update(postDoc, {'likes': likes});
      });
    } catch (e) {
      print(e);
    }
  }

  /*
    ===========================================================================
    COMENTARIOS
    ===========================================================================
  */

  // Agregar un comentario a un post
  Future<void> addComment(String postId, String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      if (user != null) {
        Comment newComment = Comment(
          id: '',
          postId: postId,
          uid: uid,
          name: user.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
        );

        Map<String, dynamic> commentMap = newComment.toMap();
        
        // Guardamos los comentarios dentro de una sub-colección del post
        await _db.collection("Posts").doc(postId).collection("Comments").add(commentMap);
      }
    } catch (e) {
      print(e);
    }
  }

  // Obtener comentarios de un post específico
  Stream<List<Comment>> getComments(String postId) {
    return _db
        .collection("Posts")
        .doc(postId)
        .collection("Comments")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    });
  }

  /*
    ===========================================================================
    REPORTAR Y BLOQUEAR (Requisito App Store)
    ===========================================================================
  */

  // Reportar usuario o post
  Future<void> reportUser(String messageId, String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    final report = {
      'reportedBy': currentUserId,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _db.collection("Reports").add(report);
  }

  // Bloquear usuario
  Future<void> blockUser(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    // Agregar a la lista de bloqueados del usuario actual
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
  }

  // Desbloquear usuario
  Future<void> unblockUser(String blockedUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();
  }

  // Obtener lista de UIDs bloqueados (para filtrar el feed)
  Stream<List<String>> getBlockedUidsStream() {
    final currentUserId = _auth.currentUser!.uid;
    
    return _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}