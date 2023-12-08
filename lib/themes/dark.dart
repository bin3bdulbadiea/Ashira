import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    color: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
    onBackground: Colors.grey[900]!,
    onPrimary: Colors.grey[100]!,
    onSecondary: Colors.grey[700]!,
    outline: Colors.grey[800],
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.grey,
    selectionHandleColor: Colors.white,
  ),
  cardTheme: const CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(),
  ),
);
