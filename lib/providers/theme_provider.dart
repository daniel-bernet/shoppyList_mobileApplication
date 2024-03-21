import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  final String _key = "isDarkMode";

  ThemeProvider() : _themeData = AppTheme.darkTheme {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = _themeData == AppTheme.darkTheme;

    _themeData = isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme;

    await prefs.setBool(_key, !isDarkMode);

    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(_key) ?? false;
    _themeData = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    
    notifyListeners();
  }
}
