import 'package:bitweather/screens/home_screen.dart';
import 'package:bitweather/services/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesService.init();

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
