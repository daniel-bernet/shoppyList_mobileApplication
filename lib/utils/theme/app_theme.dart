import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimaryColor,
        onPrimary: AppColors.lightOnPrimaryColor,
        secondary: AppColors.lightSecondaryColor,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        error: AppColors.lightWarningColor,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.lightPrimaryColor,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
        bodySmall: TextStyle(
          color: AppColors.lightSecondaryColor,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.lightSecondaryColor),
        ),
        labelStyle: TextStyle(
          color: AppColors.lightSecondaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryColor,
        onPrimary: AppColors.darkOnPrimaryColor,
        secondary: AppColors.darkSecondaryColor,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        error: AppColors.darkWarningColor,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.darkPrimaryColor,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
        bodySmall: TextStyle(
          color: AppColors.darkSecondaryColor,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.darkSecondaryColor),
        ),
        labelStyle: TextStyle(
          color: AppColors.darkSecondaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
