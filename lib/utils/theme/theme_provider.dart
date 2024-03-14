import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider({bool isDarkMode = false})
      : _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData == AppTheme.darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme;
    notifyListeners();
  }
}

