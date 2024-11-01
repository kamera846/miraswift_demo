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
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: Colors.white54,
          )),
      home: const DashboardScreen(),
    );
  }
}
