import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryOrange,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: AppColors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: AppColors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
  );

  static final ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryOrange,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryOrange,
      onPrimary: AppColors.white,
      secondary: AppColors.primaryRed,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
    ),
  );
}
