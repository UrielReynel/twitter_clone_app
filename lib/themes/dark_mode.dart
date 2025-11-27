import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,        // Fondo oscuro
    primary: Colors.grey.shade600,        // Iconos
    secondary: Colors.grey.shade800,      // Cajas un poco más claras que el fondo
    tertiary: Colors.grey.shade800,       // Inputs
    inversePrimary: Colors.grey.shade300, // Texto principal (blanco suave)
  ),
);