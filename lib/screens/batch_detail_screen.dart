import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/utils/badge.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
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
  // List<FormulaModel>? _dataFormula;
  // TabController? _tabController;
  ProductModel? _dataProduct;
  bool isLoading = true;
  double totalScales = 0.0;
  String totalTimesEquipment = '-';
  String totalTimesScales = '-';
  bool _isPanelEquipmentOpen = true;
  bool _isPanelScalesOpen = false;

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
      onCompleted: (dataEquipment, dataScales, dataProduct) {
        if (dataScales != null && dataScales.isNotEmpty) {
          var startTime = DateTime.parse(dataScales.first.createdAt);
          var endTime = DateTime.parse(dataScales.last.createdAt);
          Duration duration = endTime.difference(startTime);
          String timeFormatted = formatDuration(duration);

          setState(() {
            totalTimesScales = timeFormatted;
          });

          for (var item in dataScales) {
            setState(() {
              totalScales += double.parse(item.actualTimbang);
            });
          }
        }

        if (dataEquipment != null && dataEquipment.isNotEmpty) {
          var startTime = DateTime.parse(dataEquipment.last.timeOn);
          var endTime = DateTime.parse(dataEquipment.first.timeOff);
          Duration duration = endTime.difference(startTime);
          String timeFormatted = formatDuration(duration);

          setState(() {
            totalTimesEquipment = timeFormatted;
          });
        }

        setState(() {
          _dataEquipment = dataEquipment;
          _dataScales = dataScales;
          _dataProduct = dataProduct;
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
    int dataEquipmentIndex = 0;
    int dataScalesIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Batch - ${widget.batch.noBatch}',
            style: Theme.of(context).textTheme.titleMedium),
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
            BatchDetailHeader(
              batch: widget.batch,
              dataProduct: _dataProduct,
              totalScales: totalScales,
            ),
            _expansionSection(context, dataEquipmentIndex, dataScalesIndex),
          ],
        ),
      ),
    );
  }

  Padding _expansionSection(
      BuildContext context, int dataEquipmentIndex, int dataScalesIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ExpansionPanelList(
        elevation: 0,
        materialGapSize: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        dividerColor: Colors.transparent,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            if (panelIndex == 0) {
              _isPanelEquipmentOpen = isExpanded;
            } else {
              _isPanelScalesOpen = isExpanded;
            }
          });
        },
        children: [
          _expansionEquipment(dataEquipmentIndex),
          _expansionScales(dataScalesIndex),
        ],
      ),
    );
  }

  ExpansionPanel _expansionEquipment(int dataIndex) {
    return ExpansionPanel(
      hasIcon: false,
      canTapOnHeader: true,
      isExpanded: _isPanelEquipmentOpen,
      backgroundColor: Colors.white,
      splashColor: Colors.transparent,
      headerBuilder: (context, isExpanded) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: _isPanelEquipmentOpen
                ? LinearGradient(
                    tileMode: TileMode.clamp,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.blue.shade50, Colors.blue.shade50])
                : const LinearGradient(colors: [Colors.white, Colors.white]),
            border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
            borderRadius: _isPanelEquipmentOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))
                : BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings_applications,
                          color: Colors.grey.shade800,
                          size: 20,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text('Equipment',
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Times: $totalTimesEquipment',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                _isPanelEquipmentOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
                size: 28,
              ),
            ],
          ),
        );
      },
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
          borderRadius: _isPanelEquipmentOpen
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))
              : BorderRadius.circular(8),
        ),
        child:
            (!isLoading && _dataEquipment != null && _dataEquipment!.isNotEmpty)
                ? Column(
                    children: _dataEquipment!.map((item) {
                      final isLastIndex =
                          (dataIndex == (_dataEquipment!.length - 1));
                      dataIndex++;
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: isLastIndex ? 12 : 0,
                        ),
                        child: BatchItem.equipment(
                          equipment: item,
                          isLastIndex: isLastIndex,
                        ),
                      );
                    }).toList(),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
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
    );
  }

  ExpansionPanel _expansionScales(int dataIndex) {
    return ExpansionPanel(
      hasIcon: false,
      canTapOnHeader: true,
      isExpanded: _isPanelScalesOpen,
      backgroundColor: Colors.white,
      splashColor: Colors.transparent,
      headerBuilder: (context, isExpanded) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
          decoration: BoxDecoration(
            gradient: _isPanelScalesOpen
                ? LinearGradient(
                    tileMode: TileMode.clamp,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.blue.shade50, Colors.blue.shade50])
                : const LinearGradient(colors: [Colors.white, Colors.white]),
            border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
            borderRadius: _isPanelScalesOpen
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))
                : BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.scale_rounded,
                          color: Colors.grey.shade800,
                          size: 20,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text('Scales',
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Times: $totalTimesScales',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(' • Scales: $totalScales Kg',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                _isPanelScalesOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
                size: 28,
              ),
            ],
          ),
        );
      },
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
          borderRadius: _isPanelScalesOpen
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))
              : BorderRadius.circular(8),
        ),
        child: (!isLoading && _dataScales != null && _dataScales!.isNotEmpty)
            ? Column(
                children: _dataScales!.map((item) {
                  final isLastIndex = (dataIndex == (_dataScales!.length - 1));
                  dataIndex++;
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: isLastIndex ? 12 : 0,
                    ),
                    child: BatchItem.scales(
                      scales: item,
                      isLastIndex: isLastIndex,
                    ),
                  );
                }).toList(),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(isLoading
                      ? 'Loading..'
                      : !isLoading &&
                              (_dataScales == null || _dataScales!.isEmpty)
                          ? 'Data is empty.'
                          : ''),
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
  });

  final BatchModel batch;
  final ProductModel? dataProduct;
  final double totalScales;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(12),
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
                      'Tanggal Produksi ${formattedDate(dateStr: batch.dateEquipment)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                CustomBadge(
                  badgeText:
                      dataProduct != null ? dataProduct!.kodeProduct : '-',
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey.shade300,
          ),
          Container(
            // color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
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
                            color: Colors.green.shade900.withAlpha(150)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ON',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 16,
                      height: 16,
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
                    const SizedBox(width: 12),
                    Container(
                      width: 16,
                      height: 16,
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
