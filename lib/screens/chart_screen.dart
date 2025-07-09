import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/hero_chart_model.dart';
import 'package:miraswiftdemo/widgets/dashboard_hero_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<double> chartScaleValues = [];
  List<HeroChartModel> chartScalesData = [];
  List<double> chartTimeValues = [];
  List<HeroChartModel> chartScalesYearData = [];
  List<double> chartScaleYearValues = [];
  List<String> chartScalesYearBottomTitle = [];
  List<HeroChartModel> chartTimeData = [];

  @override
  void initState() {
    super.initState();
    generateChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chart Screen',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                DashboardHeroChart(
                  barWidth: 16,
                  title: 'Total Scales 2025',
                  unit: 'kg',
                  icon: const Icon(Icons.scale_rounded, color: Colors.blue),
                  listColorGradient: const [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ],
                  chartInterval: 20000,
                  maxChartValue: 80000,
                  listChartValue: chartScaleYearValues,
                  leftTitleKey: const ['0', '20k', '40k', '60k', '80k'],
                  leftTitleValue: const [0, 20000, 40000, 60000, 80000],
                  heroChartData: chartScalesYearData,
                  bottomTitleKey: chartScalesYearBottomTitle,
                ),
                DashboardHeroChart(
                  title: 'Best Scales',
                  unit: 'kg',
                  icon: const Icon(Icons.scale_outlined, color: Colors.green),
                  listColorGradient: const [Colors.green, Colors.lightGreen],
                  chartInterval: 250,
                  maxChartValue: 1000,
                  listChartValue: chartScaleValues,
                  leftTitleKey: const ['0', '250', '500', '750', '1K'],
                  leftTitleValue: const [0, 250, 500, 750, 1000],
                  heroChartData: chartScalesData,
                  bottomTitleKey: const ['7', '6', '5', '4', '3', '2', '1'],
                ),
                DashboardHeroChart(
                  title: 'Best Time',
                  unit: 'minutes',
                  icon: const Icon(Icons.timelapse_rounded, color: Colors.red),
                  listColorGradient: const [Colors.red, Colors.orange],
                  maxChartValue: 20,
                  chartInterval: 5,
                  listChartValue: chartTimeValues,
                  leftTitleKey: const ['0', '5', '10', '15', '20'],
                  leftTitleValue: const [0, 5, 10, 15, 20],
                  heroChartData: chartTimeData,
                  bottomTitleKey: const ['7', '6', '5', '4', '3', '2', '1'],
                ),
              ].map((item) {
                return Hero(
                  tag: item.title,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: EdgeInsets.only(
                        left: 12,
                        top: 12,
                        right: 12,
                        bottom: item.bottomTitleKey != null ? 0 : 12,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.withAlpha(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.lightBlue.withAlpha(25),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: item,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  void generateChartData() {
    // ChartScalesYear
    chartScalesYearData.add(
      const HeroChartModel(date: '01 Jan 2025', batch: '111111', value: 50000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '02 Feb 2025', batch: '222222', value: 70000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '07 Mar 2025', batch: '333333', value: 40000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '08 Apr 2025', batch: '444444', value: 60000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '09 May 2025', batch: '555555', value: 35000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '10 Jun 2025', batch: '666666', value: 30000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '11 Jul 2025', batch: '777777', value: 38000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '12 Aug 2025', batch: '888888', value: 75000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '13 Sep 2025', batch: '999999', value: 65000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '14 Okt 2025', batch: '101010', value: 78000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '15 Nov 2025', batch: '121212', value: 55000),
    );
    chartScalesYearData.add(
      const HeroChartModel(date: '16 Dec 2025', batch: '131313', value: 60000),
    );

    for (var item in chartScalesYearData) {
      chartScaleYearValues.add(item.value);
    }

    chartScalesYearBottomTitle = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D',
      // '1',
      // '2',
      // '3',
      // '4',
      // '5',
      // '6',
      // '7',
      // '8',
      // '9',
      // '10',
      // '11',
      // '12'
    ];

    // ChartScales
    chartScalesData.add(
      const HeroChartModel(date: '05 Jan 2019', batch: '123123', value: 300),
    );
    chartScalesData.add(
      const HeroChartModel(date: '06 Mar 2020', batch: '321321', value: 400),
    );
    chartScalesData.add(
      const HeroChartModel(date: '07 May 2021', batch: '111222', value: 500),
    );
    chartScalesData.add(
      const HeroChartModel(date: '08 Jul 2022', batch: '444333', value: 600),
    );
    chartScalesData.add(
      const HeroChartModel(date: '09 Sep 2023', batch: '111444', value: 700),
    );
    chartScalesData.add(
      const HeroChartModel(date: '10 Nov 2024', batch: '444111', value: 800),
    );
    chartScalesData.add(
      const HeroChartModel(date: '11 Jan 2025', batch: '123321', value: 900),
    );

    for (var item in chartScalesData) {
      chartScaleValues.add(item.value);
    }

    // Chart Time
    chartTimeData.add(
      const HeroChartModel(date: '01 Feb 2019', batch: '123123', value: 3),
    );
    chartTimeData.add(
      const HeroChartModel(date: '02 Apr 2020', batch: '321321', value: 6),
    );
    chartTimeData.add(
      const HeroChartModel(date: '03 Jun 2021', batch: '111222', value: 9),
    );
    chartTimeData.add(
      const HeroChartModel(date: '04 Aug 2022', batch: '444333', value: 12),
    );
    chartTimeData.add(
      const HeroChartModel(date: '05 Okt 2023', batch: '111444', value: 15),
    );
    chartTimeData.add(
      const HeroChartModel(date: '06 Dec 2024', batch: '444111', value: 18),
    );
    chartTimeData.add(
      const HeroChartModel(date: '07 Feb 2025', batch: '123321', value: 20),
    );

    for (var item in chartTimeData) {
      chartTimeValues.add(item.value);
    }
  }
}
