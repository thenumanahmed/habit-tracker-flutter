import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/themes_data.dart';
import 'screens/home_screen.dart';
void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open hive box
  await Hive.openBox('habit-tracker-database');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
