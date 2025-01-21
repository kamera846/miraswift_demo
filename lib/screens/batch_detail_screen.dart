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

  @override
  void initState() {
    // _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
    _getBatchDetail();
  }

  void _getBatchDetail() async {
    setState(() {
      isLoading = true;
      totalScales = 0.0;
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
          for (var item in dataScales) {
            setState(() {
              totalScales += double.parse(item.actualTimbang);
            });
          }
        }

        setState(() {
          _dataEquipment = dataEquipment;
          _dataScales = dataScales;
          _dataProduct = dataProduct;
          isLoading = false;
        });

        // _getListFormula();
      },
    );
  }

  // void _getListFormula() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await FormulaApi().list(
  //     idProduct: _dataProduct!.idProduct,
  //     onError: (msg) {
  //       if (mounted) {
  //         showSnackBar(context, msg);
  //       }
  //     },
  //     onCompleted: (data) {
  //       setState(() {
  //         _dataFormula = data;
  //         isLoading = false;
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    int dataEquipmentIndex = 0;
    int dataScalesIndex = 0;
    // int dataFormulaIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Batch Detail',
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
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_applications,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text('Equipments',
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(
                  left: 12, top: 12, right: 12, bottom: 0),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!isLoading &&
                      _dataEquipment != null &&
                      _dataEquipment!.isNotEmpty)
                  ? Column(
                      children: _dataEquipment!.map((item) {
                        final isLastIndex = (dataEquipmentIndex ==
                            (_dataEquipment!.length - 1));
                        dataEquipmentIndex++;
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
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.scale_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text('Scales', style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  (!isLoading && _dataScales != null && _dataScales!.isNotEmpty)
                      ? Column(
                          children: _dataScales!.map((item) {
                            final isLastIndex =
                                (dataScalesIndex == (_dataScales!.length - 1));
                            dataScalesIndex++;
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: isLastIndex ? 12 : 0),
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
    //   body: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       BatchDetailHeader(
    //         batch: widget.batch,
    //         dataProduct: _dataProduct,
    //         totalScales: totalScales,
    //       ),
    //       Container(
    //         margin:
    //             const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 0),
    //         decoration: BoxDecoration(
    //           border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: TabBar(
    //           controller: _tabController,
    //           indicatorSize: TabBarIndicatorSize.tab,
    //           dividerHeight: 0,
    //           labelColor: Theme.of(context).primaryColorDark,
    //           labelStyle: Theme.of(context).textTheme.titleSmall,
    //           // unselectedLabelColor: Colors.grey,
    //           unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
    //           indicatorColor: Theme.of(context).primaryColorDark,
    //           indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
    //           labelPadding: const EdgeInsets.only(top: 6),
    //           tabs: const [
    //             Tab(
    //               icon: Icon(
    //                 Icons.settings_applications,
    //                 size: 20,
    //               ),
    //               text: "Equipments",
    //             ),
    //             Tab(
    //               icon: Icon(
    //                 Icons.scale_rounded,
    //                 size: 20,
    //               ),
    //               text: "Scales",
    //             ),
    //             Tab(
    //               icon: Icon(
    //                 Icons.receipt_rounded,
    //                 size: 20,
    //               ),
    //               text: "Formula",
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: TabBarView(
    //           controller: _tabController,
    //           children: [
    //             // List Equipments
    //             SingleChildScrollView(
    //               child: Column(
    //                 children: [
    //                   Container(
    //                     padding: const EdgeInsets.symmetric(horizontal: 12),
    //                     margin: const EdgeInsets.only(
    //                         left: 12, top: 12, right: 12, bottom: 0),
    //                     decoration: BoxDecoration(
    //                       border: Border.all(
    //                           width: 1, color: Colors.grey.withAlpha(75)),
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                     child: (!isLoading &&
    //                             _dataEquipment != null &&
    //                             _dataEquipment!.isNotEmpty)
    //                         ? Column(
    //                             children: _dataEquipment!.map((item) {
    //                               final isLastIndex = (dataEquipmentIndex ==
    //                                   (_dataEquipment!.length - 1));
    //                               dataEquipmentIndex++;
    //                               return Padding(
    //                                 padding: EdgeInsets.only(
    //                                   top: 12,
    //                                   bottom: isLastIndex ? 12 : 0,
    //                                 ),
    //                                 child: BatchItem.equipment(
    //                                   equipment: item,
    //                                   isLastIndex: isLastIndex,
    //                                 ),
    //                               );
    //                             }).toList(),
    //                           )
    //                         : Center(
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(12),
    //                               child: Text(isLoading
    //                                   ? 'Loading..'
    //                                   : !isLoading &&
    //                                           (_dataEquipment == null ||
    //                                               _dataEquipment!.isEmpty)
    //                                       ? 'Data is empty.'
    //                                       : ''),
    //                             ),
    //                           ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             // List Scales
    //             SingleChildScrollView(
    //               child: Column(
    //                 children: [
    //                   Container(
    //                     padding: const EdgeInsets.symmetric(horizontal: 12),
    //                     margin: const EdgeInsets.all(12),
    //                     decoration: BoxDecoration(
    //                       border: Border.all(
    //                           width: 1, color: Colors.grey.withAlpha(75)),
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                     child: (!isLoading &&
    //                             _dataScales != null &&
    //                             _dataScales!.isNotEmpty)
    //                         ? Column(
    //                             children: _dataScales!.map((item) {
    //                               final isLastIndex = (dataScalesIndex ==
    //                                   (_dataScales!.length - 1));
    //                               dataScalesIndex++;
    //                               return Padding(
    //                                 padding: EdgeInsets.only(
    //                                     top: 12, bottom: isLastIndex ? 12 : 0),
    //                                 child: BatchItem.scales(
    //                                   scales: item,
    //                                   isLastIndex: isLastIndex,
    //                                 ),
    //                               );
    //                             }).toList(),
    //                           )
    //                         : Center(
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(12),
    //                               child: Text(isLoading
    //                                   ? 'Loading..'
    //                                   : !isLoading &&
    //                                           (_dataScales == null ||
    //                                               _dataScales!.isEmpty)
    //                                       ? 'Data is empty.'
    //                                       : ''),
    //                             ),
    //                           ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             // List Formula
    //             SingleChildScrollView(
    //               child: Column(
    //                 children: [
    //                   Container(
    //                     width: double.infinity,
    //                     margin: const EdgeInsets.all(12),
    //                     decoration: BoxDecoration(
    //                       border: Border.all(
    //                           width: 1, color: Colors.grey.withAlpha(75)),
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                     child: (!isLoading &&
    //                             _dataFormula != null &&
    //                             _dataFormula!.isNotEmpty)
    //                         ? Column(
    //                             children: _dataFormula!.map((item) {
    //                               final isLastIndex = (dataFormulaIndex ==
    //                                   (_dataFormula!.length - 1));
    //                               dataFormulaIndex++;
    //                               return Column(
    //                                 children: [
    //                                   ListTileItem(
    //                                     badge: item.kodeMaterial,
    //                                     title: item.nameMaterial,
    //                                     description:
    //                                         '${item.targetFormula} kg in ${item.timeTarget} second (Fine ${item.fineFormula} kg)',
    //                                   ),
    //                                   if (!isLastIndex)
    //                                     Divider(
    //                                       height: 0,
    //                                       color: Colors.grey.shade300,
    //                                     ),
    //                                 ],
    //                               );
    //                             }).toList(),
    //                           )
    //                         : Center(
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(12),
    //                               child: Text(
    //                                 isLoading
    //                                     ? 'Loading..'
    //                                     : !isLoading &&
    //                                             (_dataFormula == null ||
    //                                                 _dataFormula!.isEmpty)
    //                                         ? 'Data is empty.'
    //                                         : '',
    //                               ),
    //                             ),
    //                           ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Batch Number',
                      ),
                      Text(
                        batch.noBatch,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Total Scales',
                      ),
                      Text(
                        '${totalScales.toStringAsFixed(2)} KG',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Produk',
                    ),
                    Row(
                      children: [
                        Text(
                          dataProduct != null ? dataProduct!.nameProduct : '-',
                        ),
                        // const SizedBox(width: 8),
                        // CustomBadge(
                        //   badgeText: dataProduct != null
                        //       ? dataProduct!.kodeProduct
                        //       : '-',
                        // ),
                      ],
                    ),
                    Text(
                      'Tanggal Produksi ${formattedDate(dateStr: batch.dateEquipment)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
                CustomBadge(
                  badgeText:
                      dataProduct != null ? dataProduct!.kodeProduct : '-',
                ),
                // InkWell(
                //   onTap: dataProduct == null
                //       ? null
                //       : () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (ctx) => FormulaScreen(
                //                 product: dataProduct!,
                //               ),
                //             ),
                //           );
                //         },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 4,
                //     ),
                //     child: Text(
                //       dataProduct == null ? '-' : 'Detail Formula',
                //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //             color: Theme.of(context).primaryColorDark,
                //           ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status',
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
