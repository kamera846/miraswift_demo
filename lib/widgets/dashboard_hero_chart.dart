import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardHeroChart extends StatefulWidget {
  const DashboardHeroChart({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.maxChartValue,
    required this.chartInterval,
    required this.leftTitleKey,
    required this.leftTitleValue,
    required this.listChartValue,
    required this.listColorGradient,
  });
  final String title;
  final String description;
  final Icon icon;
  final double maxChartValue;
  final double chartInterval;
  final List<String> leftTitleKey;
  final List<double> leftTitleValue;
  final List<double> listChartValue;
  final List<Color> listColorGradient;
  @override
  State<StatefulWidget> createState() => DashboardHeroChartState();
}

class DashboardHeroChartState extends State<DashboardHeroChart> {
  final double width = 20;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    List<BarChartGroupData> items = [];

    for (var map in widget.listChartValue) {
      var index = widget.listChartValue.indexOf(map);
      items.add(makeGroupData(index, map));
    }

    showingBarGroups = items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.icon,
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black38,
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: 38,
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: widget.maxChartValue,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black87.withOpacity(0.7),
                  tooltipMargin: 8,
                  tooltipPadding: const EdgeInsets.only(
                    left: 16,
                    top: 12,
                    right: 16,
                    bottom: 8,
                  ),
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      'Date: 11 Maret 2025\nBatch: 09298731\nTotal: ${rod.toY}kg',
                      textAlign: TextAlign.start,
                      const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: widget.chartInterval,
                    getTitlesWidget: leftTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingBarGroups,
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    String text = '';
    int val = widget.leftTitleValue
        .indexWhere((element) => element.toDouble() == value);
    if (val != -1) {
      String key = widget.leftTitleKey[val];
      text = key;
    }

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      space: 0,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          width: width,
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: widget.listColorGradient,
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }
}
