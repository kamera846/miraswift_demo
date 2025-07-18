import 'package:flutter/material.dart';
import 'package:miraswiftdemo/screens/chart_screen.dart';
import 'package:miraswiftdemo/screens/settings_screen.dart';
import 'package:miraswiftdemo/screens/transaction_screen.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key, required this.onCallBack});

  final void Function() onCallBack;

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
    Widget nextPage;

    if (index == 0) {
      nextPage = const ChartScreen();
    } else if (index == 1) {
      nextPage = const TransactionScreen();
    } else if (index == 2) {
      nextPage = const SettingsScreen();
    } else {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => nextPage),
    ).then((_) => onCallBack);
  }
}
