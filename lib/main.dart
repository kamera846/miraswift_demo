import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          // centerTitle: true,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
        ),
        splashColor: Colors.blue.withOpacity(0.1),
      ),
      home: const DashboardScreen(),
    );
  }
}
