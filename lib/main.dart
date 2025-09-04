import 'package:flutter/material.dart';

import 'screens/language_select_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      home: const LanguageSelectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
