import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: "Poppins",
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[100],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );

    // return ThemeData(
    //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    // );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: "Poppins",
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[100],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
