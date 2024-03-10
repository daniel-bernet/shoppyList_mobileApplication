import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimaryColor,
      onPrimary: AppColors.lightOnPrimaryColor,
      secondary: AppColors.lightSecondaryColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.lightPrimaryColor, // Using primary color for titles
        fontSize: 34,
        letterSpacing: 0.5,
      ),
      bodySmall: TextStyle(
        color: AppColors.lightSecondaryColor, // Using secondary color for body text
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.lightSecondaryColor, width: 1.6),
      ),
      labelStyle: TextStyle(
        color: AppColors.lightSecondaryColor,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimaryColor,
      onPrimary: AppColors.darkOnPrimaryColor,
      secondary: AppColors.darkSecondaryColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.darkPrimaryColor, // Contrast color for dark theme titles
        fontSize: 34,
        letterSpacing: 0.5,
      ),
      bodySmall: TextStyle(
        color: AppColors.darkSecondaryColor, // Contrast color for dark theme body text
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.darkSecondaryColor, width: 1.6),
      ),
      labelStyle: TextStyle(
        color: AppColors.darkSecondaryColor,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
