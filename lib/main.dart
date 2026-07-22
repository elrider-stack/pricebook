import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const PriceBookApp());
}

class PriceBookApp extends StatelessWidget {
  const PriceBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PriceBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const HomeScreen(),
    );
  }
}
