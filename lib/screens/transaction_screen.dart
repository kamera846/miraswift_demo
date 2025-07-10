import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miraswiftdemo/models/transaction_model.dart';
import 'package:miraswiftdemo/screens/spk_available_screen.dart';
import 'package:miraswiftdemo/screens/transaction_detail_screen.dart';
import 'package:miraswiftdemo/services/transaction_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/list_tile_item.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  DateTime dateNow = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateTime visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final ScrollController _scrollController = ScrollController();
  List<TransactionModel>? _listFiltered;
  TransactionModel? _selectedItem;
  String _filterStatus = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  List<DateTime> getDaysInMonth(DateTime month) {
    // final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month - 1);
      if (visibleMonth.month == dateNow.month &&
          visibleMonth.year == dateNow.year) {
        selectedDate = dateNow;
      } else {
        selectedDate = DateTime(visibleMonth.year, visibleMonth.month, 1);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _goToNextMonth() {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month + 1);
      if (visibleMonth.month == dateNow.month &&
          visibleMonth.year == dateNow.year) {
        selectedDate = dateNow;
      } else {
        selectedDate = DateTime(visibleMonth.year, visibleMonth.month, 1);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    final days = getDaysInMonth(visibleMonth);
    final index = days.indexWhere(
      (day) =>
          day.day == selectedDate.day &&
          day.month == selectedDate.month &&
          day.year == selectedDate.year,
    );

    if (index != -1) {
      _scrollController.animateTo(
        index * 60.0, // Lebar item kira-kira 60px
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    _filterStatus = 'all';
    _getList();
  }

  void _getList() async {
    setState(() {
      _isLoading = true;
    });
    await TransactionApi().listWithFilter(
      date: formattedDate(
        dateStr: selectedDate.toString(),
        outputFormat: "yyyy-MM-dd",
      ),
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

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _filterStatus = 'all';
        visibleMonth = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
        selectedDate = visibleMonth;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysInMonth(visibleMonth);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: _isLoading == true ? null : _goToPreviousMonth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  DateFormat('MMMM yyyy').format(visibleMonth),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: _isLoading == true ? null : _goToNextMonth,
              ),
            ],
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.calendar),
            color: Colors.black,
            onPressed: _isLoading == true
                ? null
                : () {
                    _selectDate(context);
                  },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const SpkAvailableScreen(),
                  ),
                ).then((value) {
                  _scrollToSelected();
                });
              },
        backgroundColor: _isLoading ? Colors.black26 : Colors.black54,
        foregroundColor: Colors.white,
        elevation: 0,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dateSelection(days),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'List Transactions (${_listFiltered?.length ?? 0})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
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
            else if (_listFiltered == null || _listFiltered!.isEmpty)
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
            else
              ListSpk(
                onTap: (item) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => TransactionDetailScreen(
                        idTransaction: item.idTransaction,
                      ),
                    ),
                  ).then((value) {
                    _scrollToSelected();
                  });
                },
                listItem: _listFiltered!,
                selectedItem: _selectedItem,
              ),
          ],
        ),
      ),
    );
  }

  Container _dateSelection(List<DateTime> days) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected =
                day.day == selectedDate.day &&
                day.month == selectedDate.month &&
                day.year == selectedDate.year;

            return GestureDetector(
              onTap: _isLoading == true
                  ? null
                  : () {
                      setState(() {
                        selectedDate = day;
                      });
                      _scrollToSelected();
                    },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _isLoading
                            ? Colors.blue.withAlpha(50)
                            : Colors.blue.withAlpha(100)
                      : _isLoading
                      ? Colors.grey.shade200
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _isLoading
                              ? Colors.blue.withAlpha(50)
                              : Colors.blue.withAlpha(100)
                        : _isLoading
                        ? Colors.grey.shade200
                        : Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(day),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? _isLoading
                                  ? Colors.blue.shade200
                                  : Colors.blue
                            : _isLoading
                            ? Colors.black26
                            : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? _isLoading
                                  ? Colors.blue.shade200
                                  : Colors.blue
                            : _isLoading
                            ? Colors.black26
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
    this.onTap,
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
  final Function(TransactionModel item)? onTap;
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
                  onTap != null ? onTap!(item) : null;
                },
                isSelected:
                    (selectedItem != null &&
                        selectedItem!.idTransaction == item.idTransaction)
                    ? true
                    : false,
                title: formattedDate(dateStr: item.dateTransaction),
                border: !isLastIndex
                    ? Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    : null,
                description: 'Status ${item.statusTransaction}',
                customTrailingIcon: IconButton(
                  onPressed: () {
                    onTap != null ? onTap!(item) : null;
                  },
                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                customLeadingIcon: item.statusTransaction == 'PENDING'
                    ? Icon(Icons.watch_later_rounded, color: Colors.grey)
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
