import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miraswiftdemo/screens/dashboardv3_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("id_ID", null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double opacityValue = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miraswift Demo',
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
        popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        splashColor: Colors.blue.withValues(alpha: 0.1),
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
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: opacityValue,
            duration: const Duration(milliseconds: 500),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          if (opacityValue == 1) const DashboardV3Screen(),
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

  @override
  void initState() {
    changeOpacityValue();
    super.initState();
  }

  void changeOpacityValue() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        opacityValue = 1;
      });
    });
  }
}
