import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/dashboard_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Miraswift Demo',
        theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 48, 49, 139)),
        ),
        home: const DashboardScreen());
  }
}
