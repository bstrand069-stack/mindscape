import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MindScapeApp());
}

class MindScapeApp extends StatelessWidget {
  const MindScapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindScape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF75D8C4),
      ),
      home: const HomeScreen(),
    );
  }
}