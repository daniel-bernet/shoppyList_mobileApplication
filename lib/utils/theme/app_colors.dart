import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme Colors:
  static const Color lightPrimaryColor = Color(0xFF6200EE);
  static const Color lightOnPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Color(0xFF757575);
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const List<Color> lightGradient = [lightPrimaryColor, lightSecondaryColor];
  static const Color lightWarningColor = Colors.red;

  // Dark Theme Colors:
  static const Color darkPrimaryColor = Color(0xFFBB86FC);
  static const Color darkOnPrimaryColor = Colors.black;
  static const Color darkSecondaryColor = Color(0xFFBDBDBD);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF121212);
  static const List<Color> darkGradient = [darkPrimaryColor, darkSecondaryColor];
  static const Color darkWarningColor = Color(0xFFCF6679);
}
