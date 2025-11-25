import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //get instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  //get current user & uid
  User? get currentUser => _auth.currentUser;
  String? get userId => _auth.currentUser?.uid;

  //login -> email & password
  Future<User?> login(String email, String password) async {
    try{
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    }
    //catch errors
    on FirebaseAuthException catch (e){
      throw Exception(e.message);
    }
  }

  //register -> email & password
  Future<User?> registerEmailPassword(String email, String password) async {
    //Attempt to register new user
    try{
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    }
    //catch errors
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  //logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //delete account
}