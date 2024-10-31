import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/equipment_model.dart';
import 'package:miraswift_demo/services/equipment_api.dart';
import 'package:miraswift_demo/widgets/equipment.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  List<EquipmentModel>? _equipments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getEquipments();
  }

  void _getEquipments() async {
    setState(() {
      isLoading = true;
    });
    await EquipmentApiService().getEquipments(
      onSuccess: (msg) {},
      onError: (msg) {
        if (mounted) {
          _showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _equipments = data;
          isLoading = false;
        });
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Equipment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.manage_history,
                  color: Colors.grey,
                ),
                const SizedBox(width: 16),
                Text(
                  'History Equipment',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  (!isLoading && _equipments != null && _equipments!.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _equipments!.length,
                          itemBuilder: (ctx, index) {
                            final equipment = _equipments![index];
                            final isLastIndex =
                                (index == (_equipments!.length - 1));
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 16, bottom: isLastIndex ? 16 : 0),
                              child: Equipment(
                                  equipment: equipment,
                                  isLastIndex: isLastIndex),
                            );
                          })
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(isLoading
                                ? 'Loading..'
                                : !isLoading &&
                                        (_equipments == null ||
                                            _equipments!.isEmpty)
                                    ? 'Data is empty.'
                                    : ''),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
