/*
  UBICACIÓN: lib/pages/login_page.dart
*/

import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = AuthService();

  void login() async {
    try {
      await _auth.loginEmailPassword(emailController.text, passwordController.text);
      // AuthGate nos redirigirá automáticamente
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Icon(
                  Icons.lock_open,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                Text(
                  "Bienvenido de nuevo",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: emailController, 
                  hintText: "Email", 
                  obscureText: false
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController, 
                  hintText: "Contraseña", 
                  obscureText: true
                ),

                const SizedBox(height: 25),

                MyButton(
                  text: "Iniciar Sesión", 
                  onTap: login
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No eres miembro?",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Regístrate ahora",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}