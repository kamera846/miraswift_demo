import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/chart_screen.dart';
import 'package:miraswift_demo/screens/settings_screen.dart';
import 'package:miraswift_demo/screens/transactions_sreen.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: Colors.transparent,
      elevation: 0,
      onTap: (value) {
        onNavTapped(value, context);
      },
      items: _bottomNavItem,
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
        label: 'Production',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }

  void onNavTapped(int index, BuildContext context) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const ChartScreen(),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const TransactionsSreen(),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const SettingsScreen(),
        ),
      );
    }
  }
}
