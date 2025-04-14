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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const Dashboardv3Widget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: onNavTapped,
        items: _bottomNavItem,
      ),
    );
  }

  List<BottomNavigationBarItem> get _bottomNavItem {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_rounded),
        label: 'Chart',
      ),
      const BottomNavigationBarItem(
        icon: Badge(
          label: Text('2'),
          child: Icon(Icons.play_circle_fill_rounded),
        ),
        label: 'Produksi',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }

  void onNavTapped(int index) {
    setState(() {
      print('Bottom Nav Index: $index');
    });
  }
}
