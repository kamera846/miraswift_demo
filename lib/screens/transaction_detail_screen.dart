import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/spk_model.dart';
import 'package:miraswift_demo/models/transaction_detail_model.dart';
import 'package:miraswift_demo/models/transaction_model.dart';
import 'package:miraswift_demo/screens/spk_available_screen.dart';
import 'package:miraswift_demo/services/transaction_api.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

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
  TransactionModel? _detailTransaction;
  List<TransactionDetailModel> _listItem = [];
  List<SpkModel> _listSpkItem = [];
  SpkModel? _selectedItem;

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

          if (_detailTransaction != null &&
              _detailTransaction!.detail != null &&
              _detailTransaction!.detail!.isNotEmpty) {
            _listItem = _detailTransaction!.detail!;
            _isStarted = _detailTransaction?.statusTransaction == 'RUNNING';
            _isCompleted = _detailTransaction?.statusTransaction == 'COMPLETE';

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
    int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Execution Production',
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _addSpk,
            icon: const Icon(
              CupertinoIcons.add_circled_solid,
            ),
          ),
        ],
      ),
      body: _isLoading == false
          ? _listItem.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withAlpha(75)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ReorderableListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }

                              if (_isLockedItem(_listItem[oldIndex]) == true ||
                                  _isLockedItem(_listItem[newIndex]) == true) {
                                showSnackBar(
                                    context, "Failed to change list order");
                                return;
                              }

                              setState(() {
                                final TransactionDetailModel item =
                                    _listItem.removeAt(oldIndex);
                                _listItem.insert(newIndex, item);
                              });
                            },
                            children: _listItem.map((item) {
                              final isLastIndex =
                                  (index == (_listItem.length - 1));
                              index++;
                              return ListTileItem(
                                key: ValueKey(item),
                                onTap: () {
                                  // if (item.spk != null && item.spk!.currentBatch.isNotEmpty) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (ctx) =>
                                  //           BatchDetailScreen(batch: item.spk!.currentBatch),
                                  //     ),
                                  //   );
                                  // }
                                },
                                isSelected: (_selectedItem != null &&
                                        _selectedItem!.idSpk == item.idSpk)
                                    ? true
                                    : false,
                                badge: item.spk != null
                                    ? item.spk!.currentBatch
                                    : '',
                                title:
                                    item.spk != null ? item.spk!.descSpk : '',
                                border: !isLastIndex
                                    ? Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      )
                                    : null,
                                description:
                                    'Execution batch ${item.spk != null ? item.spk!.excecutedBatch : ''} of ${item.spk != null ? item.spk!.jmlBatch : ''}',
                                rightDescription: item.statusTransactionDetail,
                                customLeadingIcon: _isStarted &&
                                        (!_isLockedItem(item) || !_isStarted)
                                    ? const Icon(
                                        Icons.drag_indicator_rounded,
                                        color: Colors.black26,
                                      )
                                    : null,
                                customTrailingIcon: _isStarted &&
                                        item.statusTransactionDetail == 'DONE'
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green.shade700,
                                        ),
                                      )
                                    : _isStarted &&
                                            item.statusTransactionDetail ==
                                                'RUNNING'
                                        ? IconButton(
                                            onPressed: () {
                                              _stopTransactionDetailValidation(
                                                  item);
                                            },
                                            icon: Icon(
                                              Icons.stop_circle_rounded,
                                              color: Colors.red.shade700,
                                            ),
                                          )
                                        : _isStarted &&
                                                item.statusTransactionDetail ==
                                                    'PENDING'
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.watch_later,
                                                  color: Colors.grey.shade700,
                                                ),
                                              )
                                            : _isStarted == false &&
                                                    item.statusTransactionDetail !=
                                                        'DONE'
                                                ? IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _listItem.remove(item);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_rounded,
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    width: 16,
                                                  ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: ElevatedButton(
                        onPressed: _isCompleted ? null : _startStopValidation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isStarted
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                        ),
                        child: Text(
                          _isStarted
                              ? 'Stop All Production'
                              : 'Start Production',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      const Text('There is no spk for production yet.'),
                      const SizedBox(
                        height: 8,
                      ),
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
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Loading..',
                textAlign: TextAlign.center,
              ),
            ),
    );
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
        builder: (ctx) => SpkAvailableScreen(
          idTransaction: widget.idTransaction,
        ),
      ),
    ).then(
      (value) {
        _getList();
      },
    );
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
