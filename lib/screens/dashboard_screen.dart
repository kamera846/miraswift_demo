import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/equipment_monitoring_model.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

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
                const HMIScreen(),
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

class HMIScreen extends StatefulWidget {
  const HMIScreen({super.key});

  @override
  State<HMIScreen> createState() => _HMIScreenState();
}

class _HMIScreenState extends State<HMIScreen> {
  EquipmentModelMonitoring? data = const EquipmentModelMonitoring(
    all: null,
    valve: null,
    jetflo: null,
    mixer: null,
    screw: null,
    scales: null,
  );
  bool isLoading = true;
  bool isToggleEquipment = false;

  @override
  void initState() {
    getFirebaseData();
    super.initState();
  }

  void getFirebaseData() {
    var starCountRef = FirebaseDatabase.instance.ref('bizlink/equipment');
    starCountRef.onValue.listen((DatabaseEvent event) {
      var jsonString = jsonEncode(event.snapshot.value);
      var mapData = EquipmentModelMonitoring.fromJson(jsonDecode(jsonString));
      if (mapData.all == null || mapData.all == 'off') {
        setState(() {
          data = EquipmentModelMonitoring(
            all: mapData.all,
            valve: null,
            jetflo: null,
            mixer: null,
            screw: null,
            scales: null,
          );
          isLoading = true;
        });
      } else {
        setState(() {
          data = mapData;
          isLoading = false;
        });
      }
    });
  }

  void _toggleAllEquipment() {
    if (data != null) {
      if (data!.all != null) {
        if (data!.all == 'off') {
          showPlatformAlertDialog(
            context: context,
            title: 'Confirmation!',
            content: 'Do you want to turn on all equipment right now?',
            positiveButtonText: 'Turn On',
            positiveButtonTextColor: Colors.red,
            onPositivePressed: () async {
              if (mounted) {
                Navigator.pop(context);
              }
              await _submitUpdate('on', 500);
            },
            negativeButtonText: 'Cancel',
            negativeButtonTextColor: Colors.red,
            onNegativePressed: () => Navigator.pop(context),
          );
        } else if (data!.all == 'on') {
          _submitUpdate('off', 1500);
        }
      }
    }
  }

  Future<void> _submitUpdate(String status, int delayed) async {
    setState(() {
      isToggleEquipment = true;
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("bizlink/equipment");

    await ref.update({
      "all": status,
    });

    await Future.delayed(Duration(milliseconds: delayed));

    setState(() {
      isToggleEquipment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Equipment Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Valve: '),
              Text(
                !isLoading ? data!.valve ?? 'not found' : '...',
                style: TextStyle(
                    color: data!.valve == null
                        ? Colors.black
                        : data!.valve == 'on'
                            ? Colors.green
                            : Colors.red),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Jetflo: '),
              Text(
                !isLoading ? data!.jetflo ?? 'not found' : '...',
                style: TextStyle(
                    color: data!.jetflo == null
                        ? Colors.black
                        : data!.jetflo == 'on'
                            ? Colors.green
                            : Colors.red),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Mixer: '),
              Text(
                !isLoading ? data!.mixer ?? 'not found' : '...',
                style: TextStyle(
                    color: data!.mixer == null
                        ? Colors.black
                        : data!.mixer == 'on'
                            ? Colors.green
                            : Colors.red),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Screw: '),
              Text(
                !isLoading ? data!.screw ?? 'not found' : '...',
                style: TextStyle(
                    color: data!.screw == null
                        ? Colors.black
                        : data!.screw == 'on'
                            ? Colors.green
                            : Colors.red),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Scales: '),
              Text(
                '${!isLoading ? data!.scales ?? 'not found' : '...'}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isToggleEquipment ? null : _toggleAllEquipment,
            style: ElevatedButton.styleFrom(
              backgroundColor: isToggleEquipment
                  ? Colors.grey
                  : data!.all == 'on'
                      ? Colors.red
                      : Colors.green,
            ),
            child: Text(
              isToggleEquipment
                  ? 'Load Equipment ...'
                  : data!.all == 'on'
                      ? 'Turn Off All Equipment'
                      : 'Turn On All Equipment',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
