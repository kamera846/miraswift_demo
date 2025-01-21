import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miraswift_demo/screens/dashboard_screen.dart';
import 'package:miraswift_demo/screens/dashboardv2_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("id_ID", null);
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
        primaryColor: Colors.blue,
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
      home: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/base_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const DashboardScreen(),
          // Scaffold(
          //   backgroundColor: Colors.transparent,
          //   appBar: AppBar(
          //     backgroundColor: Colors.transparent,
          //     title: const Text('Miraswift'),
          //   ),
          //   body: const Center(
          //     child: Text('Dat content...'),
          //   ),
          // )
        ],
      ),
      // home: const DashboardScreen(),
    );
  }
}
