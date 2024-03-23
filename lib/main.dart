import 'package:bitweather/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bit-Weather',
      debugShowCheckedModeBanner: false,
      routes: ({
        '/': (context) => const HomeScreen(),
      }),
    );
  }
}
