import 'package:flutter/material.dart';
import 'light_mode.dart';
import 'dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Inicialmente usar modo claro
  ThemeData _themeData = lightMode;

  // Obtener el tema actual
  ThemeData get themeData => _themeData;

  // Saber si es modo oscuro (útil para switches)
  bool get isDarkMode => _themeData == darkMode;

  // Establecer el tema
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // ¡Avisar a la UI para que se repinte!
  }

  // Alternar entre temas
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}