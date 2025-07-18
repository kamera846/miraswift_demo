import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/spk_model.dart';
import 'package:miraswiftdemo/services/spk_api.dart';
import 'package:miraswiftdemo/services/transaction_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/list_tile_item.dart';

class SpkAvailableScreen extends StatefulWidget {
  const SpkAvailableScreen({super.key, this.idTransaction});

  final String? idTransaction;

  @override
  State<SpkAvailableScreen> createState() => SpkAvailableScreenState();
}

class SpkAvailableScreenState extends State<SpkAvailableScreen> {
  List<SpkModel>? _listItem;
  final List<String> _selectedSpk = [];
  SpkModel? _selectedItem;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getList() async {
    setState(() {
      _isLoading = true;
    });
    await SpkApi().listAvailable(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listItem = data;
          _selectedItem = null;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Spk',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      bottomNavigationBar:
          !_isLoading && _listItem != null && _listItem!.isNotEmpty
          ? SafeArea(
              child: Container(
                padding: EdgeInsetsGeometry.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: ElevatedButton(
                  onPressed: _onCreateTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSpk.isEmpty
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Create Transaction',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isLoading)
                Container(
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
                )
              else if (_listItem == null || _listItem!.isEmpty)
                Container(
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
                  child: const Text(
                    'Data is empty.',
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                ListSpk(
                  listItem: _listItem!,
                  selectedItem: _selectedItem,
                  onCheckedChanged: (value, item) {
                    int findIndex = _listItem!.indexWhere(
                      (element) => element.idSpk == item.idSpk,
                    );
                    if (findIndex != -1) {
                      setState(() {
                        _listItem![findIndex] = _listItem![findIndex].copyWith(
                          isChecked: value,
                        );
                        if (_listItem![findIndex].isChecked) {
                          _selectedSpk.add(_listItem![findIndex].idSpk);
                        } else {
                          _selectedSpk.remove(_listItem![findIndex].idSpk);
                        }
                      });
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateTransaction() async {
    if (_selectedSpk.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (widget.idTransaction != null) {
      await TransactionApi().edit(
        idTransaction: widget.idTransaction!,
        listSpk: _selectedSpk.toString(),
        onError: (msg) {
          if (mounted) {
            showSnackBar(context, msg);
          }
        },
        onCompleted: () {
          setState(() {
            Navigator.pop(context);
          });
        },
      );
    } else {
      await TransactionApi().create(
        listSpk: _selectedSpk.toString(),
        onError: (msg) {
          if (mounted) {
            showSnackBar(context, msg);
          }
        },
        onCompleted: () {
          setState(() {
            Navigator.pop(context);
          });
        },
      );
    }
  }
}

class ListSpk extends StatelessWidget {
  const ListSpk({
    super.key,
    this.title,
    required this.listItem,
    this.selectedItem,
    this.withCustomTrailing = true,
    this.onEdit,
    this.onDelete,
    this.onReorder,
    this.onCheckedChanged,
  });

  final String? title;
  final List<SpkModel> listItem;
  final SpkModel? selectedItem;
  final bool withCustomTrailing;
  final Function(SpkModel item)? onEdit;
  final Function(SpkModel item)? onDelete;
  final Function(bool? value, SpkModel item)? onCheckedChanged;
  final Function(int oldIndex, int newIndex)? onReorder;

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Column(
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.playlist_add_check_circle,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: listItem.map((item) {
              final isLastIndex = (index == (listItem.length - 1));
              index++;
              return ListTileItem(
                key: Key('$index'),
                onTap: () {
                  onCheckedChanged!(!item.isChecked, item);
                },
                isSelected:
                    (selectedItem != null && selectedItem!.idSpk == item.idSpk)
                    ? true
                    : false,
                badge: '${item.jmlBatch} Batch',
                title: item.descSpk,
                border: !isLastIndex
                    ? Border(bottom: BorderSide(color: Colors.grey.shade300))
                    : null,
                description:
                    'Jadwal untuk tanggal ${formattedDate(dateStr: item.dateSpk)}',
                customLeadingIcon: item.statusSpk == 'pending'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.schedule, color: Colors.grey),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.grey.withAlpha(50),
                          ),
                        ),
                      )
                    : item.statusSpk == 'running'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.autorenew, color: Colors.orange),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.orange.withAlpha(50),
                          ),
                        ),
                      )
                    : item.statusSpk == 'done'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.task_alt, color: Colors.green),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.green.withAlpha(50),
                          ),
                        ),
                      )
                    : IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.red.withAlpha(50),
                          ),
                        ),
                      ),
                customTrailingIcon: Checkbox(
                  value: item.isChecked,
                  onChanged: (value) {
                    if (onCheckedChanged != null) {
                      onCheckedChanged!(value, item);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
