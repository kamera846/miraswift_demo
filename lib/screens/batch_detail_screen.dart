import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/batch_item.dart';

class BatchDetailScreen extends StatefulWidget {
  const BatchDetailScreen({super.key, required this.batch});

  final BatchModel batch;

  @override
  State<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen> {
  List<BatchModel>? _dataEquipment;
  List<BatchModel>? _dataScales;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBatchDetail();
  }

  void _getBatchDetail() async {
    setState(() {
      isLoading = true;
    });
    await BatchApiService().detail(
      batchNumber: widget.batch.noBatch,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (dataEquipment, dataScales) {
        setState(() {
          _dataEquipment = dataEquipment;
          _dataScales = dataScales;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Batch Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _getBatchDetail,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Batch Number: ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        widget.batch.noBatch,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade900.withAlpha(75),
                          border: Border.all(
                              width: 2,
                              color: Colors.green.shade900.withAlpha(150)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ON',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900.withAlpha(75),
                          border: Border.all(
                              width: 2,
                              color: Colors.yellow.shade900.withAlpha(150)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RUNNING',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade900.withAlpha(75),
                          border: Border.all(
                              width: 2,
                              color: Colors.red.shade900.withAlpha(150)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'OFF',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_applications,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Equipments',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!isLoading &&
                      _dataEquipment != null &&
                      _dataEquipment!.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dataEquipment!.length,
                      itemBuilder: (ctx, index) {
                        final item = _dataEquipment![index];
                        final isLastIndex =
                            (index == (_dataEquipment!.length - 1));
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 16,
                            bottom: isLastIndex ? 16 : 0,
                          ),
                          child: BatchItem.equipment(
                            equipment: item,
                            isLastIndex: isLastIndex,
                          ),
                        );
                      })
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(isLoading
                            ? 'Loading..'
                            : !isLoading &&
                                    (_dataEquipment == null ||
                                        _dataEquipment!.isEmpty)
                                ? 'Data is empty.'
                                : ''),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.scale_rounded,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Scales',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  (!isLoading && _dataScales != null && _dataScales!.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _dataScales!.length,
                          itemBuilder: (ctx, index) {
                            final item = _dataScales![index];
                            final isLastIndex =
                                (index == (_dataScales!.length - 1));
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 16, bottom: isLastIndex ? 16 : 0),
                              child: BatchItem.scales(
                                scales: item,
                                isLastIndex: isLastIndex,
                              ),
                            );
                          })
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(isLoading
                                ? 'Loading..'
                                : !isLoading &&
                                        (_dataScales == null ||
                                            _dataScales!.isEmpty)
                                    ? 'Data is empty.'
                                    : ''),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
