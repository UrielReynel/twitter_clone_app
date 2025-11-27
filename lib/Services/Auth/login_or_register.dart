/*
  UBICACIÓN: lib/services/auth/login_or_register.dart
*/

import 'package:flutter/material.dart';
import '../../pages/login_page.dart';
import '../../pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Inicialmente mostrar página de Login
  bool showLoginPage = true;

  // Función para alternar páginas
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}