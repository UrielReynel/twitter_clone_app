/*
  UBICACIÓN: lib/services/auth/auth_service.dart
*/

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instancia de Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Obtener usuario actual
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Obtener UID actual (muy útil para consultas a la BD)
  String getCurrentUid() {
    return _firebaseAuth.currentUser!.uid;
  }

  // Iniciar Sesión (Login)
  Future<UserCredential> loginEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Registrarse (Sign Up)
  Future<UserCredential> registerEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Cerrar Sesión (Logout)
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}