import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miraswiftdemo/models/transaction_model.dart';
import 'package:miraswiftdemo/screens/spk_available_screen.dart';
import 'package:miraswiftdemo/screens/transaction_detail_screen.dart';
import 'package:miraswiftdemo/services/transaction_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';

class TransactionScreen extends StatefulWidget {
  final String? date;
  const TransactionScreen({super.key, this.date});

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  DateTime dateNow = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateTime visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final ScrollController _scrollController = ScrollController();
  List<TransactionModel>? _listFiltered;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) {
      DateTime dateParams = DateFormat("yyyy-MM-dd").parse(widget.date ?? "-");
      selectedDate = dateParams;
      visibleMonth = DateTime(dateParams.year, dateParams.month);
    }
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
      status: 'all',
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listFiltered = data;
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
              InkWell(
                onTap: _isLoading == true ? null : _goToPreviousMonth,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(Icons.chevron_left),
                ),
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

              InkWell(
                onTap: _isLoading == true ? null : _goToNextMonth,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(Icons.chevron_right),
                ),
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
        backgroundColor: _isLoading ? Colors.black26 : Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _dateSelection(days),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
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
                      ListView.separated(
                        itemCount: _listFiltered?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = _listFiltered![index];
                          return _transactionItem(context, item);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionItem(BuildContext context, TransactionModel item) {
    IconData icon = Icons.schedule;
    Color color = Colors.grey;
    if (item.statusTransaction == 'RUNNING') {
      icon = Icons.autorenew;
      color = Colors.orange;
    } else if (item.statusTransaction == 'NOT_COMPLETE') {
      icon = Icons.warning_amber;
      color = Colors.red;
    } else if (item.statusTransaction == 'COMPLETE') {
      icon = Icons.task_alt;
      color = Colors.green;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                TransactionDetailScreen(idTransaction: item.idTransaction),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Card(
        color: Colors.transparent,
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
                  Text(
                    "Transaction Item",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "ID ${item.idTransaction}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.statusTransaction,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.event, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate(
                      dateStr: item.dateTransaction,
                      inputFormat: 'yyyy-MM-dd HH:mm:ss',
                      outputFormat: 'dd MMM yyyy, HH:mm:ss',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.withAlpha(75)),
              Row(
                children: [
                  Text(
                    "Detail Item",
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
