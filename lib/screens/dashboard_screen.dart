import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String? equipmentStatus;
  @override
  void initState() {
    getFirebaseData();
    super.initState();
  }

  void getFirebaseData() {
    setState(() {
      equipmentStatus = null;
    });
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Bizlink/equipment');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      // print('Equipment Status: $data');
      setState(() {
        equipmentStatus = '$data';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dashboard is coming soon..'),
            Text('Equipment Status: ${equipmentStatus ?? 'waiting...'}'),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
    );
  }
}
