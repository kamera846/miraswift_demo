import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/spk_model.dart';
import 'package:miraswiftdemo/models/transaction_detail_model.dart';
import 'package:miraswiftdemo/models/transaction_model.dart';
import 'package:miraswiftdemo/screens/batch_screen.dart';
import 'package:miraswiftdemo/screens/spk_available_screen.dart';
import 'package:miraswiftdemo/services/transaction_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key, required this.idTransaction});

  final String idTransaction;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool _isLoading = true;
  bool _isStarted = false;
  bool _isCompleted = false;
  Color _transactionStatusColor = Colors.grey;
  TransactionModel? _detailTransaction;
  List<TransactionDetailModel> _listItem = [];
  List<SpkModel> _listSpkItem = [];

  @override
  void initState() {
    super.initState();
    _listItem = [];
    _listSpkItem = [];
    _detailTransaction = null;
    _getList();
  }

  void _getList() async {
    setState(() {
      _isLoading = true;
    });
    await TransactionApi().detail(
      id: widget.idTransaction,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _detailTransaction = data;

          if (_detailTransaction != null) {
            if (_detailTransaction?.statusTransaction == 'RUNNING') {
              _transactionStatusColor = Colors.orange;
            } else if (_detailTransaction?.statusTransaction ==
                'NOT_COMPLETE') {
              _transactionStatusColor = Colors.red;
            } else if (_detailTransaction?.statusTransaction == 'COMPLETE') {
              _transactionStatusColor = Colors.green;
            }
          }

          if (_detailTransaction != null &&
              _detailTransaction!.detail != null &&
              _detailTransaction!.detail!.isNotEmpty) {
            _listItem = _detailTransaction!.detail!;
            _isStarted = _detailTransaction?.statusTransaction == 'RUNNING';
            _isCompleted =
                _detailTransaction?.statusTransaction == 'COMPLETE' ||
                _detailTransaction?.statusTransaction == 'NOT_COMPLETE';

            for (var element in _listItem) {
              if (element.spk != null) {
                _listSpkItem.add(element.spk!);
              }
            }
          }

          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction ID ${_detailTransaction?.idTransaction ?? "-"}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _addSpk,
            icon: const Icon(CupertinoIcons.add_circled_solid),
          ),
        ],
      ),
      bottomNavigationBar: _isLoading == false && _listItem.isNotEmpty
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: ElevatedButton(
                  onPressed: _isCompleted ? null : _startStopValidation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isStarted
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                  ),
                  child: Text(
                    _isStarted ? 'Stop All Production' : 'Start Production',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: _isLoading == false
            ? _listItem.isNotEmpty
                  ? ReorderableListView.builder(
                      itemBuilder: (context, index) {
                        final item = _listItem[index];
                        return Container(
                          key: ValueKey(item),
                          padding: EdgeInsetsGeometry.all(8),
                          color: Colors.white,
                          child: _transactionDetailItem(context, item, index),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }

                        if (_isLockedItem(_listItem[oldIndex]) == true ||
                            _isLockedItem(_listItem[newIndex]) == true) {
                          showSnackBar(context, "Failed to change list order");
                          return;
                        }

                        setState(() {
                          final TransactionDetailModel item = _listItem
                              .removeAt(oldIndex);
                          _listItem.insert(newIndex, item);
                        });
                      },
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      header: Padding(
                        padding: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Transaction ${formattedDate(dateStr: _detailTransaction?.dateTransaction ?? "-", inputFormat: 'yyyy-MM-dd HH:mm:ss', outputFormat: 'dd MMM yyyy, HH:mm:ss')}",
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _transactionStatusColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _detailTransaction?.statusTransaction ?? "-",
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: _transactionStatusColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemCount: _listItem.length,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          const Text('There is no spk for production yet.'),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: _addSpk,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text('Select Spk'),
                            ),
                          ),
                        ],
                      ),
                    )
            : Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.withAlpha(75),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Loading..', textAlign: TextAlign.center),
              ),
      ),
    );
  }

  Widget _transactionDetailItem(
    BuildContext context,
    TransactionDetailModel item,
    int index,
  ) {
    IconData icon = Icons.schedule;
    Color color = Colors.grey;
    if (item.statusTransactionDetail == 'RUNNING') {
      icon = Icons.autorenew;
      color = Colors.orange;
    } else if (item.statusTransactionDetail == 'STOPPED') {
      icon = Icons.warning_amber;
      color = Colors.red;
    } else if (item.statusTransactionDetail == 'DONE') {
      icon = Icons.task_alt;
      color = Colors.green;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BatchScreen(
              idProduct: item.spk?.idProduct,
              date: _detailTransaction?.dateTransaction,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
          side: BorderSide(color: Colors.grey.withAlpha(75)),
        ),
        margin: EdgeInsets.all(0),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: null,
                    icon: Icon(icon, color: color, size: 20),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        color.withAlpha(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.spk?.descSpk ?? '-',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Text(
                      //   "Batch ${item.spk?.currentBatch}",
                      //   style: Theme.of(context).textTheme.bodySmall,
                      // ),
                    ],
                  ),
                  Spacer(),
                  _generateActionItem(item),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blue),
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   child: Text(
                  //     "${index + 1}",
                  //     style: Theme.of(
                  //       context,
                  //     ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                  //   ),
                  // ),
                  _isStarted && (!_isLockedItem(item) || !_isStarted)
                      ? Icon(
                          Icons.drag_indicator_rounded,
                          color: Colors.grey.shade400,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.statusTransactionDetail,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(CupertinoIcons.cube_box, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "Batch • ${item.spk?.currentBatch}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  Text(
                    "${item.spk?.excecutedBatch}/${item.spk?.jmlBatch}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value:
                    double.parse(item.spk?.excecutedBatch ?? "0") /
                    double.parse(item.spk?.jmlBatch ?? "0"),
                borderRadius: BorderRadius.circular(50),
                minHeight: 5,
                backgroundColor: color.withAlpha(50),
                valueColor: AlwaysStoppedAnimation(color.withAlpha(150)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Show List Batch",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Column _oldItems(BuildContext context, int index) {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: SingleChildScrollView(
  //           child: Container(
  //             margin: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: ReorderableListView(
  //               physics: const NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               onReorder: (int oldIndex, int newIndex) {
  //                 if (oldIndex < newIndex) {
  //                   newIndex -= 1;
  //                 }

  //                 if (_isLockedItem(_listItem[oldIndex]) == true ||
  //                     _isLockedItem(_listItem[newIndex]) == true) {
  //                   showSnackBar(context, "Failed to change list order");
  //                   return;
  //                 }

  //                 setState(() {
  //                   final TransactionDetailModel item = _listItem.removeAt(
  //                     oldIndex,
  //                   );
  //                   _listItem.insert(newIndex, item);
  //                 });
  //               },
  //               children: _listItem.map((item) {
  //                 final isLastIndex = (index == (_listItem.length - 1));
  //                 index++;
  //                 return ListTileItem(
  //                   key: ValueKey(item),
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (ctx) => BatchScreen(
  //                           idProduct: item.spk?.idProduct,
  //                           date: _detailTransaction?.dateTransaction,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   isSelected:
  //                       (_selectedItem != null &&
  //                           _selectedItem!.idSpk == item.idSpk)
  //                       ? true
  //                       : false,
  //                   badge: item.spk != null ? item.spk!.currentBatch : '',
  //                   title: item.spk != null ? item.spk!.descSpk : '',
  //                   border: !isLastIndex
  //                       ? Border(
  //                           bottom: BorderSide(
  //                             width: 1,
  //                             color: Colors.grey.shade300,
  //                           ),
  //                         )
  //                       : null,
  //                   description:
  //                       'Execution batch ${item.spk != null ? item.spk!.excecutedBatch : ''} of ${item.spk != null ? item.spk!.jmlBatch : ''}',
  //                   rightDescription: item.statusTransactionDetail,
  //                   customLeadingIcon:
  //                       _isStarted && (!_isLockedItem(item) || !_isStarted)
  //                       ? const Icon(
  //                           Icons.drag_indicator_rounded,
  //                           color: Colors.black26,
  //                         )
  //                       : null,
  //                   customTrailingIcon:
  //                       _isStarted && item.statusTransactionDetail == 'DONE'
  //                       ? IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(
  //                             Icons.check_circle_rounded,
  //                             color: Colors.green.shade700,
  //                           ),
  //                         )
  //                       : _isStarted &&
  //                             item.statusTransactionDetail == 'RUNNING'
  //                       ? IconButton(
  //                           onPressed: () {
  //                             _stopTransactionDetailValidation(item);
  //                           },
  //                           icon: Icon(
  //                             Icons.stop_circle_rounded,
  //                             color: Colors.red.shade700,
  //                           ),
  //                         )
  //                       : _isStarted &&
  //                             item.statusTransactionDetail == 'PENDING'
  //                       ? IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(
  //                             Icons.watch_later,
  //                             color: Colors.grey.shade700,
  //                           ),
  //                         )
  //                       : _isStarted == false &&
  //                             item.statusTransactionDetail != 'DONE'
  //                       ? IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               _listItem.remove(item);
  //                             });
  //                           },
  //                           icon: const Icon(Icons.delete_rounded),
  //                         )
  //                       : const SizedBox(width: 16),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
  //         child: ElevatedButton(
  //           onPressed: _isCompleted ? null : _startStopValidation,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: _isStarted
  //                 ? Colors.red.shade800
  //                 : Colors.green.shade800,
  //           ),
  //           child: Text(
  //             _isStarted ? 'Stop All Production' : 'Start Production',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _generateActionItem(TransactionDetailModel item) {
    return _isStarted && item.statusTransactionDetail == 'RUNNING'
        ? IconButton.outlined(
            onPressed: () => _stopTransactionDetailValidation(item),
            icon: Icon(Icons.stop_rounded, color: Colors.red.shade600),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red.shade100),
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.red.shade200),
              ),
            ),
          )
        : _isStarted == false && item.statusTransactionDetail != 'DONE'
        ? IconButton.outlined(
            onPressed: () => _deleteTransactionDetailValidation(item),
            icon: Icon(Icons.delete_rounded, color: Colors.grey.shade600),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade200),
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.grey.shade300),
              ),
            ),
          )
        : const SizedBox(width: 16);
  }

  bool _isLockedItem(TransactionDetailModel item) {
    if (item.statusTransactionDetail != 'PENDING') {
      return true;
    } else {
      return false;
    }
  }

  void _addSpk() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) =>
            SpkAvailableScreen(idTransaction: widget.idTransaction),
      ),
    ).then((value) {
      _getList();
    });
  }

  void _startStopValidation() async {
    var title = 'Confirmation!';
    var content = 'Do you want to start production now?';
    var positiveButtonText = 'Start Now';
    var positiveButtonTextColor = CupertinoColors.systemBlue;

    if (_isStarted) {
      title = 'Warning!!';
      content = 'Are you sure you want to stop all production proccess?';
      positiveButtonText = 'Stop Now';
      positiveButtonTextColor = CupertinoColors.systemRed;
    }

    showPlatformAlertDialog(
      context: context,
      title: title,
      content: content,
      positiveButtonText: positiveButtonText,
      positiveButtonTextColor: positiveButtonTextColor,
      onPositivePressed: _startButtonHandler,
      negativeButtonText: 'Cancel',
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _startButtonHandler() async {
    if (_isStarted) {
      await _stopTransaction();
    } else {
      await _startTransaction();
    }
  }

  Future _startTransaction() async {
    setState(() {
      _isLoading = true;
    });

    await TransactionApi().start(
      idTransaction: widget.idTransaction,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onSuccess: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: () {
        _getList();
      },
    );
  }

  Future _stopTransaction() async {
    setState(() {
      _isLoading = true;
    });

    await TransactionApi().stopTransaction(
      idTransaction: widget.idTransaction,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onSuccess: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: () {
        _getList();
      },
    );
  }

  void _deleteTransactionDetailValidation(TransactionDetailModel item) {
    showPlatformAlertDialog(
      context: context,
      title: 'Warning!!',
      content:
          'Are you sure you want to delete ${item.spk != null ? item.spk!.descSpk : ''}?',
      positiveButtonText: 'Delete',
      positiveButtonTextColor: CupertinoColors.systemRed,
      onPositivePressed: () {
        setState(() {
          _listItem.remove(item);
        });
      },
      negativeButtonText: 'Cancel',
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _stopTransactionDetailValidation(TransactionDetailModel item) {
    showPlatformAlertDialog(
      context: context,
      title: 'Warning!!',
      content:
          'Are you sure you want to stop ${item.spk != null ? item.spk!.descSpk : ''} production proccess?',
      positiveButtonText: 'Stop Now',
      positiveButtonTextColor: CupertinoColors.systemRed,
      onPositivePressed: () => _stopTransactionDetail(item.idTransactionDetail),
      negativeButtonText: 'Cancel',
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _stopTransactionDetail(String idTransactionDetail) async {
    setState(() {
      _isLoading = true;
    });

    await TransactionApi().stopTransactionDetail(
      idTransactionDetail: idTransactionDetail,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onSuccess: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: () {
        _getList();
      },
    );
  }
}
