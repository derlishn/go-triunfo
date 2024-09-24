import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => LightTheme.themeData;
  static ThemeData get darkTheme => DarkTheme.themeData;
}
