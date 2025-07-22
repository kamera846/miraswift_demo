import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/frequency_model.dart';
import 'package:miraswiftdemo/services/frequency_api.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';

class SettingsHzScreen extends StatefulWidget {
  const SettingsHzScreen({super.key});

  @override
  SettingsHzScreenState createState() => SettingsHzScreenState();
}

class SettingsHzScreenState extends State<SettingsHzScreen> {
  String _idFrequency = '-1';
  bool isLoading = true;

  int _semenHigh = 0;
  int _semenLow = 0;
  int _kapurHigh = 0;
  int _kapurLow = 0;
  int _pasirKasarHigh = 0;
  int _pasirKasarLow = 0;
  int _pasirHalusHigh = 0;
  int _pasirHalusLow = 0;
  int _semenPutihHigh = 0;
  int _semenPutihLow = 0;

  @override
  void initState() {
    _setupItem();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setupItem() async {
    setState(() {
      isLoading = true;
    });
    await FrequencyApi().detail(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (item) async {
        if (item != null) {
          setState(() {
            _idFrequency = item.idFrequency;
            _semenHigh = int.tryParse(item.semenHigh) != null
                ? int.parse(item.semenHigh)
                : 0;
            _semenLow = int.tryParse(item.semenLow) != null
                ? int.parse(item.semenLow)
                : 0;
            _kapurHigh = int.tryParse(item.kapurHigh) != null
                ? int.parse(item.kapurHigh)
                : 0;
            _kapurLow = int.tryParse(item.kapurLow) != null
                ? int.parse(item.kapurLow)
                : 0;
            _pasirKasarHigh = int.tryParse(item.pasirKasarHigh) != null
                ? int.parse(item.pasirKasarHigh)
                : 0;
            _pasirKasarLow = int.tryParse(item.pasirKasarLow) != null
                ? int.parse(item.pasirKasarLow)
                : 0;
            _pasirHalusHigh = int.tryParse(item.pasirHalusHigh) != null
                ? int.parse(item.pasirHalusHigh)
                : 0;
            _pasirHalusLow = int.tryParse(item.pasirHalusLow) != null
                ? int.parse(item.pasirHalusLow)
                : 0;
            _semenPutihHigh = int.tryParse(item.semenPutihHigh) != null
                ? int.parse(item.semenPutihHigh)
                : 0;
            _semenPutihLow = int.tryParse(item.semenPutihLow) != null
                ? int.parse(item.semenPutihLow)
                : 0;
          });
        }

        setState(() {
          isLoading = false;
        });
      },
    );
  }

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
        _submitEdit();
      },
    );
  }

  void _submitEdit() async {
    setState(() {
      isLoading = true;
    });
    await FrequencyApi().save(
      item: FrequencyModel(
        idFrequency: _idFrequency,
        semenHigh: '$_semenHigh',
        semenLow: '$_semenLow',
        kapurHigh: '$_kapurHigh',
        kapurLow: '$_kapurLow',
        pasirKasarHigh: '$_pasirKasarHigh',
        pasirKasarLow: '$_pasirKasarLow',
        pasirHalusHigh: '$_pasirHalusHigh',
        pasirHalusLow: '$_pasirHalusLow',
        semenPutihHigh: '$_semenPutihHigh',
        semenPutihLow: '$_semenPutihLow',
        createdAt: '',
        updatedAt: '',
      ),
      onSuccess: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: () {
        setState(() {
          isLoading = false;
        });
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                      _semenHigh,
                      _semenLow,
                      (high) => setState(() => _semenHigh = high),
                      (low) => setState(() => _semenLow = low),
                    ),
                    const SizedBox(height: 12.0),
                    _buildFormInput(
                      'Kapur',
                      _kapurHigh,
                      _kapurLow,
                      (high) => setState(() => _kapurHigh = high),
                      (low) => setState(() => _kapurLow = low),
                    ),
                    const SizedBox(height: 12.0),
                    _buildFormInput(
                      'Pasir Kasar',
                      _pasirKasarHigh,
                      _pasirKasarLow,
                      (high) => setState(() => _pasirKasarHigh = high),
                      (low) => setState(() => _pasirKasarLow = low),
                    ),
                    const SizedBox(height: 12.0),
                    _buildFormInput(
                      'Pasir Halus',
                      _pasirHalusHigh,
                      _pasirHalusLow,
                      (high) => setState(() => _pasirHalusHigh = high),
                      (low) => setState(() => _pasirHalusLow = low),
                    ),
                    const SizedBox(height: 12.0),
                    _buildFormInput(
                      'Semen Putih',
                      _semenPutihHigh,
                      _semenPutihLow,
                      (high) => setState(() => _semenPutihHigh = high),
                      (low) => setState(() => _semenPutihLow = low),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
              isLoading
                  ? CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      onPressed: () => _confirmSubmit(context),
                      child: const Text('Save Settings'),
                    ),
              const SizedBox(height: 12.0),
            ],
          ),
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
                allowedInteraction: SliderInteraction.slideOnly,
                label: highValue.toString(),
                value: highValue.toDouble(),
                min: 0,
                max: 50,
                onChanged: isLoading
                    ? null
                    : (value) => onHighChanged(value.toInt()),
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
                onChanged: isLoading
                    ? null
                    : (value) => onLowChanged(value.toInt()),
              ),
            ),
            Text('($lowValue)Hz', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
