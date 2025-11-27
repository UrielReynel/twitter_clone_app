import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Este archivo lo genera FlutterFire CLI
import 'services/auth/auth_gate.dart';
import 'themes/theme_provider.dart';

void main() async {
  // Asegurar que los widgets estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Correr la App envuelta en el Provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quitar la etiqueta "Debug"
      
      // Conectar el tema con el Provider
      theme: Provider.of<ThemeProvider>(context).themeData,
      
      // La puerta de entrada (decide si mostrar Login o Home)
      home: const AuthGate(),
    );
  }
}