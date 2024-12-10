import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/screens/batch_detail_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({super.key});

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  List<BatchModel>? _batchs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBatchs();
  }

  void _getBatchs() async {
    setState(() {
      isLoading = true;
    });
    await BatchApiService().batchs(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _batchs = data;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Batch', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.miscellaneous_services_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('List Batch',
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!isLoading && _batchs != null && _batchs!.isNotEmpty)
                  ? Column(
                      children: _batchs!.map((item) {
                        final isLastIndex = (index == (_batchs!.length - 1));
                        index++;
                        return Column(
                          children: [
                            ListTileItem(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        BatchDetailScreen(batch: item),
                                  ),
                                );
                              },
                              customTrailingIcon: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          BatchDetailScreen(batch: item),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                              title: item.noBatch,
                              description:
                                  formattedDate(dateStr: item.dateEquipment),
                            ),
                            if (!isLastIndex)
                              Divider(
                                height: 0,
                                color: Colors.grey.shade300,
                              ),
                          ],
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(isLoading
                            ? 'Loading..'
                            : !isLoading &&
                                    (_batchs == null || _batchs!.isEmpty)
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
