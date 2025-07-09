import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/equipment_monitoring_model.dart';
import 'package:miraswiftdemo/services/api.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class MonitoringEquipment extends StatefulWidget {
  const MonitoringEquipment({super.key});

  @override
  State<MonitoringEquipment> createState() => _MonitoringEquipmentState();
}

class _MonitoringEquipmentState extends State<MonitoringEquipment> {
  EquipmentModelMonitoring? data = const EquipmentModelMonitoring(
    all: null,
    valve: null,
    jetflo: null,
    mixer: null,
    screw: null,
    scales: null,
  );
  bool isLoading = true;
  bool isToggleEquipment = true;

  @override
  void initState() {
    getFirebaseData();
    super.initState();
  }

  void getFirebaseData() {
    try {
      var starCountRef = FirebaseDatabase.instance.ref('bizlink/equipment');
      starCountRef.onValue
          .listen((DatabaseEvent event) {
            var jsonString = jsonEncode(event.snapshot.value);
            var mapData = EquipmentModelMonitoring.fromJson(
              jsonDecode(jsonString),
            );
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
            setState(() {
              isToggleEquipment = false;
            });
          })
          .onError((e) {
            if (mounted) showSnackBar(context, e.message);
          });
    } catch (e) {
      if (mounted) showSnackBar(context, '$failedRequestText. Exception: $e');
    }
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

    await ref.update({"all": status});

    await Future.delayed(Duration(milliseconds: delayed));

    setState(() {
      isToggleEquipment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 12),
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
                      : Colors.red,
                ),
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
                      : Colors.red,
                ),
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
                      : Colors.red,
                ),
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
                      : Colors.red,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Scales: '),
              Text(!isLoading ? data!.scales ?? 'not found' : '...'),
            ],
          ),
          const SizedBox(height: 12),
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
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
