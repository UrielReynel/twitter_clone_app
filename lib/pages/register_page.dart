/*
  UBICACIÓN: lib/pages/register_page.dart
*/

import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Servicios
  final _auth = AuthService();
  final _db = DatabaseService();

  // Función de registro
  void register() async {
    // Verificar que las contraseñas coincidan
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // 1. Crear usuario en Firebase Auth
        await _auth.registerEmailPassword(
          emailController.text, 
          passwordController.text
        );

        // 2. Guardar perfil en la Base de Datos (Firestore)
        // Esto es crucial para que el perfil tenga nombre y bio
        await _db.saveUserInfoInFirebase(
          name: nameController.text, 
          email: emailController.text
        );

        // Si todo sale bien, AuthGate nos llevará al Home automáticamente
        
      } catch (e) {
        // Mostrar error si falla
        if (mounted) {
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    } else {
      // Contraseñas no coinciden
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(
          title: Text("Las contraseñas no coinciden"),
        ),
      );
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

                // Logo
                Icon(
                  Icons.lock,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                // Texto de bienvenida
                Text(
                  "Vamos a crear una cuenta",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Inputs
                MyTextField(
                  controller: nameController, 
                  hintText: "Nombre", 
                  obscureText: false
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController, 
                  hintText: "Confirmar contraseña", 
                  obscureText: true
                ),

                const SizedBox(height: 25),

                // Botón Registrar
                MyButton(
                  text: "Registrarse", 
                  onTap: register
                ),

                const SizedBox(height: 25),

                // Ir a Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes cuenta?",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Inicia sesión aquí",
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