import 'package:flutter/material.dart';
import 'package:miraswiftdemo/screens/settings_hz_screen.dart';

class PanelScreen extends StatefulWidget {
  const PanelScreen({super.key});

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _settingsEquipment() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsHzScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Monitoring Equipments',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: _settingsEquipment,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: onNavTapped,
        currentIndex: _currentPageIndex,
        items: _bottomNavItem,
      ),
      body: SizedBox.expand(
        child: PageView(
          onPageChanged: pageListener,
          controller: _pageController,
          children: _bottomNavPageItem,
        ),
      ),
    );
  }

  List<Widget> get _bottomNavPageItem {
    return [1, 2, 3].map((item) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 194, 189, 165),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(1, 1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: indicatorView(item),
      );
    }).toList();
  }

  Widget indicatorView(int item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'PANEL $item',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          // Green Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IndicatorWidget.greenOff(title: 'Off'),
              IndicatorWidget.greenOn(title: 'On'),
              IndicatorWidget.greenOn(title: 'On'),
              IndicatorWidget.greenOn(title: 'On'),
              IndicatorWidget.greenOff(title: 'Off'),
            ],
          ),
          const SizedBox(height: 16),
          // Red Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IndicatorWidget.redOff(title: 'Off'),
              IndicatorWidget.redOn(title: 'On'),
              IndicatorWidget.redOff(title: 'Off'),
            ],
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> get _bottomNavItem {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.curtains_closed_rounded),
        label: 'Panel 1',
      ),
      BottomNavigationBarItem(
        icon: Badge(child: Icon(Icons.curtains_closed_rounded)),
        label: 'Panel 2',
      ),
      BottomNavigationBarItem(
        icon: Badge(
          label: Text('2'),
          child: Icon(Icons.curtains_closed_rounded),
        ),
        label: 'Panel 3',
      ),
    ];
  }

  void pageListener(value) {
    setState(() {
      _currentPageIndex = value;
    });
  }

  void onNavTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }
}

class IndicatorWidget extends StatelessWidget {
  IndicatorWidget.greenOff({super.key, required this.title})
    : listColor = [
        Colors.green.shade600,
        Colors.green.shade800,
        Colors.black38,
      ];
  IndicatorWidget.greenOn({super.key, required this.title})
    : listColor = [
        Colors.lightGreenAccent.shade400,
        Colors.lightGreenAccent.shade700,
        Colors.lightGreenAccent,
      ];
  IndicatorWidget.redOff({super.key, required this.title})
    : listColor = [
        Colors.red.shade600.withAlpha(150),
        Colors.red.shade900,
        Colors.black38,
      ];
  IndicatorWidget.redOn({super.key, required this.title})
    : listColor = [
        Colors.redAccent,
        Colors.redAccent.shade700.withAlpha(120),
        Colors.redAccent.shade400,
      ];

  final String title;
  final List<Color> listColor;

  @override
  Widget build(BuildContext context) {
    double indicatorSize = 40;

    return Column(
      children: [
        Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: listColor[0],
            borderRadius: BorderRadius.circular(indicatorSize),
            border: Border.all(width: 4, color: listColor[1]),
            boxShadow: [BoxShadow(color: listColor[2], blurRadius: 12)],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          width: indicatorSize + 20,
          color: Colors.white38,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
