/*
  UBICACIÓN: lib/services/database/database_service.dart
  ESTADO: COMPLETO FINAL (Incluye Posts por Usuario, Search, Follow, Moderación)
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
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '', 
    );

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

  // Buscar usuarios por nombre
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
      UserProfile? user = await getUserFromFirebase(uid);

      if (user != null) {
        Post newPost = Post(
          id: '', // Firebase genera el ID
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

  // Obtener TODOS los posts (Para el Home)
  Stream<List<Post>> getAllPosts() {
    final currentUserId = _auth.currentUser!.uid;
    
    return _db
        .collection("Posts")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Obtener lista de usuarios bloqueados
      final blockedUsersSnapshot = await _db
          .collection("Users")
          .doc(currentUserId)
          .collection("BlockedUsers")
          .get();
      
      final blockedUids = blockedUsersSnapshot.docs.map((doc) => doc.id).toList();
      
      // Filtrar posts de usuarios bloqueados
      return snapshot.docs
          .map((doc) => Post.fromDocument(doc))
          .where((post) => !blockedUids.contains(post.uid))
          .toList();
    });
  }

  // Obtener posts de un USUARIO ESPECÍFICO (Para el Perfil)
  Stream<List<Post>> getPostsByUser(String uid) {
    return _db
        .collection("Posts")
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
        })
        .handleError((error) {
          print('Error al cargar posts: $error');
          return <Post>[];
        });
  }

  // Borrar post
  Future<void> deletePost(String postId) async {
    await _db.collection("Posts").doc(postId).delete();
  }

  /*
    ===========================================================================
    LIKES
    ===========================================================================
  */

  Future<void> toggleLike(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);
        List<String> likes = List<String>.from(postSnapshot['likes'] ?? []);

        if (likes.contains(uid)) {
          likes.remove(uid);
        } else {
          likes.add(uid);
        }

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
        await _db.collection("Posts").doc(postId).collection("Comments").add(commentMap);
      }
    } catch (e) {
      print(e);
    }
  }

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
    SEGUIR (FOLLOW SYSTEM)
    ===========================================================================
  */

  Future<void> followUser(String uidToFollow) async {
    final currentUid = _auth.currentUser!.uid;

    // Agregar a mi lista de "Following"
    await _db
        .collection("Users")
        .doc(currentUid)
        .collection("Following")
        .doc(uidToFollow)
        .set({});

    // Agregarme a su lista de "Followers"
    await _db
        .collection("Users")
        .doc(uidToFollow)
        .collection("Followers")
        .doc(currentUid)
        .set({});
  }

  Future<void> unfollowUser(String uidToUnfollow) async {
    final currentUid = _auth.currentUser!.uid;

    // Quitar de mi "Following"
    await _db
        .collection("Users")
        .doc(currentUid)
        .collection("Following")
        .doc(uidToUnfollow)
        .delete();

    // Quitar de su "Followers"
    await _db
        .collection("Users")
        .doc(uidToUnfollow)
        .collection("Followers")
        .doc(currentUid)
        .delete();
  }

  Future<bool> isFollowing(String uid) async {
    final currentUid = _auth.currentUser!.uid;
    final doc = await _db
        .collection("Users")
        .doc(currentUid)
        .collection("Following")
        .doc(uid)
        .get();
    return doc.exists;
  }

  Stream<int> getFollowerCount(String uid) {
    return _db
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getFollowingCount(String uid) {
    return _db
        .collection("Users")
        .doc(uid)
        .collection("Following")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /*
    ===========================================================================
    REPORTAR Y BLOQUEAR (MODERACIÓN)
    ===========================================================================
  */

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

  Future<void> blockUser(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
  }

  Future<void> unblockUser(String blockedUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();
  }

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