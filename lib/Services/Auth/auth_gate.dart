import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone_app/Services/Auth/login_or_register.dart';
import 'package:twitter_clone_app/pages/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          //User is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}