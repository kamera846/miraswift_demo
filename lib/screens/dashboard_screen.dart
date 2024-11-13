import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/widgets/monitoring_equipment.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const EquipmentScreen(),
                      ),
                    );
                  },
                  child: const Text('Open Equipment'),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
