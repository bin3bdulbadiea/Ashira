import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.grey[300],
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.grey[200]!,
    secondary: Colors.grey[500]!,
    onPrimary: Colors.grey[900]!,
    onSecondary: Colors.grey[600]!,
    outline: Colors.grey[400],
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.grey,
    selectionHandleColor: Colors.black,
  ),
  cardTheme: const CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(),
  ),
);
