import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestDateConcept extends StatefulWidget {
  const TestDateConcept({super.key});

  @override
  TestDateConceptState createState() => TestDateConceptState();
}

class TestDateConceptState extends State<TestDateConcept> {
  DateTime dateNow = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateTime visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final ScrollController _scrollController = ScrollController();

  List<DateTime> getDaysInMonth(DateTime month) {
    // final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
        lastDay.day, (index) => DateTime(month.year, month.month, index + 1));
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
    final index = days.indexWhere((day) =>
        day.day == selectedDate.day &&
        day.month == selectedDate.month &&
        day.year == selectedDate.year);

    if (index != -1) {
      _scrollController.animateTo(
        index * 60.0, // Lebar item kira-kira 60px
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysInMonth(visibleMonth);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black),
              onPressed: _goToPreviousMonth,
            ),
            Text(
              DateFormat('MMMM yyyy').format(visibleMonth),
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.black),
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Icon(Icons.access_time, color: Colors.black),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day.day == selectedDate.day &&
                  day.month == selectedDate.month &&
                  day.year == selectedDate.year;

              return GestureDetector(
                onTap: () {
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
                    color: isSelected ? Colors.brown : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
