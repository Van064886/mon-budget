import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mon_budget/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: "Poppins",
      // primarySwatch: AppConstants.mainColor,
      scaffoldBackgroundColor: AppConstants.primaryColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.mainColor,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.mainColor,
        foregroundColor: Colors.white,
        elevation: 3,
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 13),
        displayMedium: TextStyle(fontSize: 13),
        displaySmall: TextStyle(fontSize: 13),
        headlineLarge: TextStyle(fontSize: 13),
        headlineMedium: TextStyle(fontSize: 13),
        headlineSmall: TextStyle(fontSize: 13),
        titleLarge: TextStyle(fontSize: 13),
        titleMedium: TextStyle(fontSize: 13),
        titleSmall: TextStyle(fontSize: 13),
        bodyLarge: TextStyle(fontSize: 13),
        bodyMedium: TextStyle(fontSize: 13),
        bodySmall: TextStyle(fontSize: 13),
        labelLarge: TextStyle(fontSize: 13),
        labelMedium: TextStyle(fontSize: 13),
        labelSmall: TextStyle(fontSize: 13),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: "Poppins",
      // primarySwatch: AppConstants.mainColor,
      scaffoldBackgroundColor: Colors.grey[100],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.mainColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.mainColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
