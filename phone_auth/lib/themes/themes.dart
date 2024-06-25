import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    displayLarge: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    displayMedium: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    displaySmall: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(
    displaySmall: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    displayLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    displayMedium: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
  ),
);
