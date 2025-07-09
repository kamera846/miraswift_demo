import 'package:flutter/material.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';

class FormSettingsEquipment extends StatefulWidget {
  const FormSettingsEquipment({super.key});

  @override
  FormSettingsEquipmentState createState() => FormSettingsEquipmentState();
}

class FormSettingsEquipmentState extends State<FormSettingsEquipment> {
  int _highSemen = 50;
  int _lowSemen = 25;
  int _highKapur = 50;
  int _lowKapur = 25;
  int _highKasar = 50;
  int _lowKasar = 25;
  int _highHalus = 50;
  int _lowHalus = 25;
  int _highPutih = 50;
  int _lowPutih = 25;

  @override
  void initState() {
    _setupItem();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setupItem() {}

  void _confirmSubmit(BuildContext context) {
    showPlatformAlertDialog(
      context: context,
      title: 'Warning!',
      content: 'Are you sure you want to change the equipment settings?',
      negativeButtonText: 'Cancel',
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
      positiveButtonText: 'Submit',
      onPositivePressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings Equipment',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormInput(
                    'Semen',
                    _highSemen,
                    _lowSemen,
                    (high) => setState(() => _highSemen = high),
                    (low) => setState(() => _lowSemen = low),
                  ),
                  const SizedBox(height: 12.0),
                  _buildFormInput(
                    'Kapur',
                    _highKapur,
                    _lowKapur,
                    (high) => setState(() => _highKapur = high),
                    (low) => setState(() => _lowKapur = low),
                  ),
                  const SizedBox(height: 12.0),
                  _buildFormInput(
                    'Pasir Kasar',
                    _highKasar,
                    _lowKasar,
                    (high) => setState(() => _highKasar = high),
                    (low) => setState(() => _lowKasar = low),
                  ),
                  const SizedBox(height: 12.0),
                  _buildFormInput(
                    'Pasir Halus',
                    _highHalus,
                    _lowHalus,
                    (high) => setState(() => _highHalus = high),
                    (low) => setState(() => _lowHalus = low),
                  ),
                  const SizedBox(height: 12.0),
                  _buildFormInput(
                    'Semen Putih',
                    _highPutih,
                    _lowPutih,
                    (high) => setState(() => _highPutih = high),
                    (low) => setState(() => _lowPutih = low),
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _confirmSubmit(context),
              child: const Text('Save Settings'),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFormInput(
    String label,
    int highValue,
    int lowValue,
    Function(int high) onHighChanged,
    Function(int low) onLowChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Text('High', style: Theme.of(context).textTheme.bodySmall),
            Expanded(
              child: Slider.adaptive(
                label: highValue.toString(),
                value: highValue.toDouble(),
                min: 0,
                max: 50,
                onChanged: (value) => onHighChanged(value.toInt()),
              ),
            ),
            Text(
              '($highValue)Hz',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Row(
          children: [
            Text('Low', style: Theme.of(context).textTheme.bodySmall),
            Expanded(
              child: Slider.adaptive(
                label: lowValue.toString(),
                value: lowValue.toDouble(),
                min: 0,
                max: 50,
                onChanged: (value) => onLowChanged(value.toInt()),
              ),
            ),
            Text('($lowValue)Hz', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
