/*
  UBICACIÓN: lib/services/auth/auth_gate.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_register.dart';
import '../../pages/home_page.dart'; // Asegúrate de que la ruta a home_page sea correcta

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Si el usuario está logueado
          if (snapshot.hasData) {
            return const HomePage();
          }
          
          // Si el usuario NO está logueado
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}