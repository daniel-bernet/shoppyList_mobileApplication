import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color lightPrimaryColor = Color(0xFF6200EE);  // A more appealing blue shade
  static const Color lightOnPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Color(0xFF757575);  // Complementary secondary color
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const List<Color> lightGradient = [lightPrimaryColor, lightSecondaryColor];

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFFBB86FC);  // A purple shade for primary color
  static const Color darkOnPrimaryColor = Colors.black;
  static const Color darkSecondaryColor = Color(0xFFBDBDBD);  // Similar to light for consistency
  static const Color darkBackground = Color(0xFF121212);  // A darker shade for background
  static const Color darkSurface = Color(0xFF121212);
  static const List<Color> darkGradient = [darkPrimaryColor, darkSecondaryColor];
}
