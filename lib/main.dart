import 'package:animeate/pages/Android/home_page.dart';
import 'package:animeate/pages/Android/screens/loading_screen.dart';
import 'package:animeate/Provider/theme_providers.dart';
import 'package:animeate/pages/windows/windows_home.dart';
import 'package:animeate/themes/dark_theme.dart';
import 'package:animeate/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            "HomeMobile": (context) => const MobileHomePage(),
            "HomeWindows": (context) => const WindowsHome(),
          },
          title: 'Theme Switcher',
          theme: themeProvider.isDarkTheme
              ? DarkTheme.theme // Dark theme
              : LightTheme.theme, // Light theme
          home: const LoadingScreen(),
        );
      },
    );
  }
}
