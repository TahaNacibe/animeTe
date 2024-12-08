import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black, // Set scaffold background color
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A), // Deep dark grey
      ),
     
    );
  }
}
