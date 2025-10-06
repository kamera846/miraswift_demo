import 'package:flutter/material.dart';
import 'package:miraswiftdemo/screens/settings_hz_screen.dart';

class ScadaScreen extends StatefulWidget {
  const ScadaScreen({super.key});

  @override
  State<ScadaScreen> createState() => _ScadaScreenState();
}

class _ScadaScreenState extends State<ScadaScreen> {
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
      backgroundColor: Colors.blueGrey.shade700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Monitoring Scada',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white),
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
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
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
    return ["MU", "AVIAN", "SIKA"].map((item) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(8),
          child: RotatedBox(
            quarterTurns: 45,
            child: Image.asset(
              'assets/images/scada_mu.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
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
        label: 'MU',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.curtains_closed_rounded),
        label: 'AVIAN',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.curtains_closed_rounded),
        label: 'SIKA',
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
