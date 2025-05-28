import 'package:flutter/material.dart';
import 'package:miraswift_demo/widgets/dashboard_bottom_nav.dart';
import 'package:miraswift_demo/widgets/dashboardv3_widget.dart';

class DashboardV3Screen extends StatefulWidget {
  const DashboardV3Screen({super.key});

  @override
  State<DashboardV3Screen> createState() => _DashboarV2dScreenState();
}

class _DashboarV2dScreenState extends State<DashboardV3Screen> {
  bool onLoaded = false;
  final GlobalKey<Dashboardv3WidgetState> dashboardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dashboardv3Widget(
        key: dashboardKey,
        onLoaded: (bool state) {
          setState(() {
            onLoaded = state;
          });
        },
      ),
      bottomNavigationBar:
          onLoaded ? DashboardBottomNav(dashboardKey: dashboardKey) : null,
    );
  }
}
