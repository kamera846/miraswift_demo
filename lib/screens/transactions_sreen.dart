import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/transaction_model.dart';
import 'package:miraswift_demo/screens/production_screen.dart';
import 'package:miraswift_demo/screens/spk_available_screen.dart';
import 'package:miraswift_demo/services/transaction_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class TransactionsSreen extends StatefulWidget {
  const TransactionsSreen({super.key});

  @override
  State<TransactionsSreen> createState() => _TransactionsSreenState();
}

class _TransactionsSreenState extends State<TransactionsSreen> {
  List<TransactionModel>? _listFiltered;
  TransactionModel? _selectedItem;
  bool _isLoading = true;
  String _filterStatus = 'all';

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var dateNow = DateTime.now();
    _dateController.text = "${dateNow.toLocal()}".split(' ')[0];
    _filterStatus = 'all';
    _getList();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _getList() async {
    setState(() {
      _listFiltered = null;
      _isLoading = true;
    });
    await TransactionApi().listWithFilter(
      date: _dateController.text,
      status: _filterStatus,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listFiltered = data;
          _selectedItem = null;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _filterStatus = 'all';
        _dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format to yyyy-mm-dd
      });
      _getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions',
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SpkAvailableScreen(),
                      ),
                    ).then(
                      (value) {
                        _getList();
                      },
                    );
                  },
            icon: const Icon(
              CupertinoIcons.add_circled_solid,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                onTap: () {
                  if (!_isLoading) {
                    FocusScope.of(context).unfocus();
                    _selectDate(context);
                  }
                },
                controller: _dateController,
                readOnly: true,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.blue,
                    ),
                decoration: InputDecoration(
                  hintText: 'Click date icon to filter',
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _dateController.text.isNotEmpty
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  prefixIcon: InkWell(
                    onTap: () {
                      if (!_isLoading) {
                        FocusScope.of(context).unfocus();
                        _selectDate(context);
                      }
                    },
                    child: const Icon(
                      CupertinoIcons.calendar,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ['all', 'pending', 'running', 'done', 'stopped']
                    .map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        if (!_isLoading) {
                          setState(() {
                            _filterStatus = item;
                          });
                          _getList();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _filterStatus == item
                              ? _isLoading
                                  ? Colors.blue.withAlpha(50)
                                  : Colors.blue.withAlpha(100)
                              : _isLoading
                                  ? Colors.grey.shade200
                                  : Colors.black12,
                        ),
                        backgroundColor: _filterStatus == item
                            ? _isLoading
                                ? Colors.blue.withAlpha(50)
                                : Colors.blue.withAlpha(100)
                            : _isLoading
                                ? Colors.grey.shade200
                                : Colors.black12,
                        padding: const EdgeInsets.all(14),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        item.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: _filterStatus == item
                                  ? _isLoading
                                      ? Colors.blue.shade200
                                      : Colors.blue
                                  : _isLoading
                                      ? Colors.black26
                                      : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_isLoading)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Loading..',
                  textAlign: TextAlign.center,
                ),
              )
            else if (_listFiltered == null || _listFiltered!.isEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Data is empty.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListSpk(
                listItem: _listFiltered!,
                selectedItem: _selectedItem,
              )
          ],
        ),
      ),
    );
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
  });

  final String? title;
  final List<TransactionModel> listItem;
  final TransactionModel? selectedItem;
  final bool withCustomTrailing;
  final Function(TransactionModel item)? onEdit;
  final Function(TransactionModel item)? onDelete;
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
                    Text(title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ProductionScreen(
                        idTransaction: item.idTransaction,
                      ),
                    ),
                  );
                },
                isSelected: (selectedItem != null &&
                        selectedItem!.idTransaction == item.idTransaction)
                    ? true
                    : false,
                title: formattedDate(dateStr: item.dateTransaction),
                border: !isLastIndex
                    ? Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade300))
                    : null,
                description: 'Status ${item.statusTransaction}',
                customLeadingIcon: item.statusTransaction == 'PENDING'
                    ? Icon(
                        Icons.watch_later_rounded,
                        color: Colors.grey.shade700,
                      )
                    : item.statusTransaction == 'RUNNING'
                        ? Icon(
                            Icons.timelapse_rounded,
                            color: Colors.yellow.shade900,
                          )
                        : item.statusTransaction == 'COMPLETE'
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green.shade700,
                              )
                            : Icon(
                                Icons.stop_circle_rounded,
                                color: Colors.red.shade700,
                              ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
