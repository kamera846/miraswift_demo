import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/screens/batch_detail_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Batch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.miscellaneous_services_rounded,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Batch',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!isLoading && _batchs != null && _batchs!.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _batchs!.length,
                      itemBuilder: (ctx, index) {
                        final item = _batchs![index];
                        final isLastIndex = (index == (_batchs!.length - 1));
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
                              title: item.noBatch,
                              description: '2024-11-05 08:49:48',
                            ),
                            if (!isLastIndex)
                              Divider(
                                height: 0,
                                color: Colors.grey.withAlpha(75),
                              ),
                          ],
                        );
                      })
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
