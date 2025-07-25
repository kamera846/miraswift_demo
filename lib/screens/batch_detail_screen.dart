import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/batch_model.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/services/api.dart';
import 'package:miraswiftdemo/services/batch_api.dart';
import 'package:miraswiftdemo/utils/badge.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/formatted_time.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/batch_item.dart';

class BatchDetailScreen extends StatefulWidget {
  const BatchDetailScreen({super.key, required this.batch});

  final BatchModel batch;

  @override
  State<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen> {
  List<Map<String, String?>> _dataTimes = [];
  List<BatchModel>? _dataEquipment;
  List<BatchModel>? _dataScales;
  ProductModel? _dataProduct;
  ApiResponse? _batchDetail;
  bool isLoading = true;
  double totalScales = 0.0;
  String totalTimesEquipment = '-';
  String totalTimesScales = '-';

  @override
  void initState() {
    super.initState();
    _getBatchDetail();
  }

  void _getBatchDetail() async {
    setState(() {
      isLoading = true;
      totalScales = 0.0;
      totalTimesEquipment = '-';
      totalTimesScales = '-';
      _dataProduct = null;
    });
    await BatchApiService().detail(
      batchNumber: widget.batch.noBatch,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted:
          (
            dataEquipment,
            dataScales,
            dataProduct,
            totalEquipmentTime,
            totalMaterialTime,
            batchDetail,
          ) async {
            if (dataScales != null && dataScales.isNotEmpty) {
              try {
                for (var item in dataScales) {
                  setState(() {
                    totalScales += double.parse(item.actualTimbang);
                  });
                }
              } catch (e) {
                setState(() {
                  totalScales = 0.0;
                });
              }
            }

            setState(() {
              totalTimesEquipment = formatTime(
                totalEquipmentTime ?? '00:00:00',
              );
              totalTimesScales = formatTime(totalMaterialTime ?? '00:00:00');
              if (dataEquipment != null && dataEquipment.isNotEmpty) {
                dataEquipment.sort((a, b) => a.timeOn.compareTo(b.timeOn));
              }

              _dataEquipment = dataEquipment;
              _dataScales = dataScales;
              _dataProduct = dataProduct;
              _batchDetail = batchDetail;

              _dataTimes = [
                {
                  'value': _batchDetail?.totalEquipmentTime,
                  'label': 'Cycle Time',
                  'desc': 'Total waktu dari feeding + discharge.',
                  'icon': '🔁',
                },
                {
                  'value': _batchDetail?.totalMaterialTime,
                  'label': 'Material',
                  'desc': 'Total waktu untuk transfer material.',
                  'icon': '📦',
                },
                {
                  'value': _batchDetail?.totalFeedingTime,
                  'label': 'Feeding',
                  'desc':
                      'Total waktu dari material pertama sampai material terakhir.',
                  'icon': '🔽',
                },
                {
                  'value': _batchDetail?.totalDelayTime,
                  'label': 'Delay',
                  'desc': 'Total waktu tunda dari setiap equipment.',
                  'icon': '⌛',
                },
              ];

              isLoading = false;
            });
          },
    );
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes mnt $seconds scnd';
  }

  @override
  Widget build(BuildContext context) {
    int dataTimeIndex = 0;
    int dataEquipmentIndex = 0;
    int dataScalesIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Batch ${widget.batch.noBatch}',
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _getBatchDetail,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            BatchDetailHeader(
              batch: widget.batch,
              dataProduct: _dataProduct,
              totalScales: totalScales,
              batchDetail: _batchDetail,
            ),
            _accordionSection(
              context,
              dataTimeIndex,
              dataEquipmentIndex,
              dataScalesIndex,
            ),
          ],
        ),
      ),
    );
  }

  Accordion _accordionSection(
    BuildContext context,
    int dataTimeIndex,
    int dataEquipmentIndex,
    int dataScalesIndex,
  ) {
    return Accordion(
      maxOpenSections: 3,
      accordionId: 'accordion-batch',
      headerPadding: const EdgeInsets.all(12),
      headerBorderRadius: 8,
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.blue.shade50,
      headerBackgroundColor: Colors.white,
      headerBorderColor: Colors.grey.withAlpha(75),
      flipRightIconIfOpen: true,
      rightIcon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
        size: 28,
      ),
      contentBackgroundColor: Colors.white,
      contentBorderRadius: 8,
      contentBorderWidth: 1,
      contentBorderColor: Colors.grey.withAlpha(75),
      contentHorizontalPadding: 12,
      contentVerticalPadding: 0,
      scaleWhenAnimating: false,
      disableScrolling: true,
      children: [
        _accordionTime(context, dataTimeIndex),
        _accordionItem(
          context,
          'Equipment',
          // 'Times: $totalTimesEquipment',
          null,
          Icons.settings_applications,
          _dataEquipment,
          dataEquipmentIndex,
        ),
        _accordionItem(
          context,
          'Scales',
          // 'Times: $totalTimesScales • Scales: ${totalScales.toStringAsFixed(2)} Kg',
          'Total Scales: ${totalScales.toStringAsFixed(2)} KG',
          Icons.scale_rounded,
          _dataScales,
          dataEquipmentIndex,
        ),
      ],
    );
  }

  AccordionSection _accordionTime(BuildContext context, int dataTimeIndex) {
    return AccordionSection(
      isOpen: true,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                color: Colors.grey.shade800,
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Time Report',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ],
      ),
      content: (!isLoading && _dataTimes.isNotEmpty)
          ? Column(
              children: _dataTimes.asMap().entries.map((entry) {
                final item = entry.value;
                final isLastIndex = (dataTimeIndex == (_dataTimes.length - 1));
                dataTimeIndex++;
                return Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: isLastIndex ? 12 : 0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['label'] as String,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item['icon'] as String} ${item['desc'] as String}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatTime(item['value'] as String),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      if (!isLastIndex) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Divider(
                            height: 0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  isLoading
                      ? 'Loading..'
                      : !isLoading && _dataTimes.isEmpty
                      ? 'Data is empty.'
                      : '',
                ),
              ),
            ),
    );
  }

  AccordionSection _accordionItem(
    BuildContext context,
    String title,
    String? description,
    IconData icon,
    List<BatchModel>? items,
    int itemIndex,
  ) {
    return AccordionSection(
      isOpen: true,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade800, size: 20),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
      content: (!isLoading && items != null && items.isNotEmpty)
          ? Column(
              children: items.map((item) {
                final isLastIndex = (itemIndex == (items.length - 1));
                itemIndex++;
                return Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: isLastIndex ? 12 : 0,
                  ),
                  child: title == 'Equipment'
                      ? BatchItem.equipment(
                          equipment: item,
                          isLastIndex: isLastIndex,
                        )
                      : BatchItem.scales(
                          scales: item,
                          isLastIndex: isLastIndex,
                        ),
                );
              }).toList(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  isLoading
                      ? 'Loading..'
                      : !isLoading && (items == null || items.isEmpty)
                      ? 'Data is empty.'
                      : '',
                ),
              ),
            ),
    );
  }
}

class BatchDetailHeader extends StatelessWidget {
  const BatchDetailHeader({
    super.key,
    required this.batch,
    required this.dataProduct,
    required this.totalScales,
    required this.batchDetail,
  });

  final BatchModel batch;
  final ProductModel? dataProduct;
  final double totalScales;
  final ApiResponse? batchDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataProduct != null ? dataProduct!.nameProduct : '-',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    Text(
                      'SPK ${batch.spk?.descSpk} • ${formattedDate(dateStr: batch.dateEquipment)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                CustomBadge(
                  badgeText: dataProduct != null
                      ? dataProduct!.kodeProduct
                      : '-',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status', style: Theme.of(context).textTheme.titleSmall!),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade900.withAlpha(75),
                        border: Border.all(
                          width: 2,
                          color: Colors.green.shade900.withAlpha(150),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('ON', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Container(
                      width: 16,
                      height: 16,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade900.withAlpha(75),
                        border: Border.all(
                          width: 2,
                          color: Colors.yellow.shade900.withAlpha(150),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RUNNING',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 16,
                      height: 16,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withAlpha(75),
                        border: Border.all(
                          width: 2,
                          color: Colors.red.shade900.withAlpha(150),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('OFF', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
