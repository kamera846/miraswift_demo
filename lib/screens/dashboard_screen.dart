import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? valveStatus = 'waiting...';
  String? jetfloStatus = 'waiting...';
  String? mixerStatus = 'waiting...';
  String? screwStatus = 'waiting...';
  String? scalesValue = 'waiting...';
  String? allEquipmentStatus = 'waiting...';
  bool? isEquipmentOn;

  @override
  void initState() {
    getFirebaseData();
    super.initState();
  }

  void getFirebaseData() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('bizlink/equipment');
    starCountRef.child('screw').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          screwStatus = data.toString().toUpperCase();
        });
      }
    });
    starCountRef.child('timbangan').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          scalesValue = data.toString().toUpperCase();
        });
      }
    });
    starCountRef.child('all').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          allEquipmentStatus = data.toString();
        });
      }
    });

    setState(() {
      valveStatus = null;
      jetfloStatus = null;
      mixerStatus = null;
    });
  }

  void _toggleEquipmentStatus() {
    if (isEquipmentOn != null) {
      if (isEquipmentOn!) {
        showPlatformAlertDialog(
            context: context,
            title: 'Warning',
            content: 'Are you sure to turn off all equipment?',
            positiveButtonText: 'Turn Off',
            positiveButtonTextColor: Colors.red,
            onPositivePressed: _submitUpdate);
      } else {
        _submitUpdate();
      }
    }
  }

  void _submitUpdate() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("bizlink/equipment");

    await ref.update({
      "all": isEquipmentOn! ? 'off' : 'on',
    });

    if (!isEquipmentOn!) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allEquipmentStatus == 'waiting...' || allEquipmentStatus == null) {
      setState(() {
        isEquipmentOn = null;
      });
    } else if (allEquipmentStatus == 'on') {
      setState(() {
        isEquipmentOn = true;
      });
    } else {
      setState(() {
        isEquipmentOn = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Dashboard is coming soon..'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text('Equipment Status'),
                    ),
                    const SizedBox(height: 12),
                    Text('Screw: ${screwStatus ?? 'Not Found'}'),
                    Text('Scales: ${scalesValue ?? 'Not Found'}'),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: isEquipmentOn == null
                            ? null
                            : _toggleEquipmentStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEquipmentOn == null
                              ? Colors.grey
                              : isEquipmentOn == true
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        child: Text(
                          isEquipmentOn == null
                              ? 'Waiting...'
                              : isEquipmentOn == true
                                  ? 'Turn Off'
                                  : 'Turn On',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
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
                      builder: (ctx) => const EquipmentScreen(),
                    ),
                  );
                },
                child: const Text('Open Equipment'),
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
            ],
          ),
        ),
      ),
    );
  }
}
