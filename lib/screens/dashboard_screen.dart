import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/notifications_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/screens/spk_screen.dart';
import 'package:miraswift_demo/widgets/monitoring_equipment.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _badgeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Dashboard', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (crx) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
              if (_badgeCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (crx) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _badgeCount < 10 ? _badgeCount.toString() : '9+',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/images/miraswift_transparent.png'),
                ),
                const SizedBox(height: 32),
                const MonitoringEquipment(),
                // const SizedBox(height: 12),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor:
                //         Theme.of(context).colorScheme.primaryContainer,
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (ctx) => const EquipmentScreen(),
                //       ),
                //     );
                //   },
                //   child: const Text('Open Equipment'),
                // ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const BatchScreen(),
                      ),
                    );
                  },
                  child: const Text('Open Batch'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ProductScreen(),
                      ),
                    );
                  },
                  child: const Text('Setting Recipe'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const SpkScreen(),
                      ),
                    );
                  },
                  child: const Text('Setting SPK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
