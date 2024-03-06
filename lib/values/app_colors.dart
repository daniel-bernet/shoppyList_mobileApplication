import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color lightPrimaryColor = Colors.blue;
  static const Color lightOnPrimaryColor = Colors.white;
  static const Color lightSecondaryColor = Colors.black54;
  static const List<Color> lightGradient = [lightPrimaryColor, lightSecondaryColor];

  // Dark Theme Colors
  static const Color darkPrimaryColor = Colors.orange;
  static const Color darkOnPrimaryColor = Colors.black;
  static const Color darkSecondaryColor = Colors.grey;
  static const List<Color> darkGradient = [darkPrimaryColor, darkSecondaryColor];
}
