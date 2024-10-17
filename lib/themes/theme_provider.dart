import 'package:flutter/material.dart';
import 'package:truckerfinal/themes/dark_mode.dart';
import 'package:truckerfinal/themes/light_mode.dart';
// Change from dark or light mode

class ThemeProvider with ChangeNotifier {
  //initially set as light mode
  ThemeData _themeData = lightMode;

  // get the current theme
  ThemeData get themeData => _themeData;

  // is it dark mode?
  bool get isDarkMode => _themeData == darkMode;

  // set the theme

  set themeData(ThemeData themeData) {
    _themeData = themeData;

    //update ui
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
