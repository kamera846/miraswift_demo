import 'package:flutter/material.dart';
import 'package:miraswift_demo/widgets/dashboardv3_widget.dart';

class DashboardV3Screen extends StatefulWidget {
  const DashboardV3Screen({super.key});

  @override
  State<DashboardV3Screen> createState() => _DashboarV2dScreenState();
}

class _DashboarV2dScreenState extends State<DashboardV3Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Dashboardv3Widget(),
    );
  }
}
