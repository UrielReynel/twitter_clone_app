import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,        // Fondo general
    primary: Colors.grey.shade500,        // Iconos y textos secundarios
    secondary: Colors.grey.shade200,      // Fondo de cajas/tiles
    tertiary: Colors.white,               // Fondo de inputs/alto contraste
    inversePrimary: Colors.grey.shade900, // Texto principal (negro suave)
  ),
);