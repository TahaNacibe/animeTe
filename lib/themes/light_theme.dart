import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    // Define a milky color (light beige)
    final Color milkyColor = Color(0xFFF8F6F1);

    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white, // Set scaffold background color
      appBarTheme: AppBarTheme(
        backgroundColor: milkyColor, // Milky color for app bar
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: milkyColor, // Milky color for bottom nav bar
      ),
    );
  }
}
