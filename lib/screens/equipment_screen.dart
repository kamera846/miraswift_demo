import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/equipment_model.dart';
import 'package:miraswift_demo/services/equipment_api.dart';
import 'package:miraswift_demo/widgets/equipment_status.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  List<EquipmentModel>? _equipments;
  bool isLoading = true;
  String? selectedCategory = 'ALL';
  List<String> categories = ['ALL', 'JETFLO', 'MIXER'];

  @override
  void initState() {
    super.initState();
    _getEquipments();
  }

  void _getEquipments({String? category}) async {
    setState(() {
      isLoading = true;
    });
    await EquipmentApiService().getEquipments(
      category: category,
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Equipment',
              style: Theme.of(context).textTheme.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category,
                        style: Theme.of(context).textTheme.bodySmall),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  if (selectedCategory == 'ALL') {
                    _getEquipments();
                  } else {
                    _getEquipments(category: selectedCategory);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Equipment', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (selectedCategory == null || selectedCategory != 'ALL')
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.black54,
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    'Filtered by category $selectedCategory',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.manage_history,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'History Equipment',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.all(12),
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
                                  top: 16, bottom: isLastIndex ? 12 : 0),
                              child: EquipmentStatus(
                                  equipment: equipment,
                                  isLastIndex: isLastIndex),
                            );
                          })
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
