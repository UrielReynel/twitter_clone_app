import 'package:flutter/material.dart';
import 'light_mode.dart';
import 'dark_mode.dart';

/*
Change between lightMode and darkMode 
*/

class ThemeProvider with ChangeNotifier {
    //Initial theme = lightMode
    ThemeData _themeData = lightMode;
    
    //Get the current theme
    ThemeData get themeData => _themeData;

    bool get isDarkMode => _themeData == darkMode;

    //Set theme
    void setTheme(ThemeData themeData) {
        _themeData = themeData;
        //Update UI
        notifyListeners();
    }

    void toggleTheme() {
        if(_themeData == lightMode) {
            setTheme(darkMode);
        } else {
            setTheme(lightMode);
        }
    }
}