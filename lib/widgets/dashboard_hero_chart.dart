import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/hero_chart_model.dart';

class DashboardHeroChart extends StatefulWidget {
  const DashboardHeroChart({
    super.key,
    this.barWidth = 24,
    this.barSpace = 2,
    required this.title,
    required this.unit,
    required this.icon,
    required this.maxChartValue,
    required this.chartInterval,
    required this.leftTitleKey,
    required this.leftTitleValue,
    this.bottomTitleKey,
    required this.listChartValue,
    required this.listColorGradient,
    required this.heroChartData,
  });
  final double barWidth;
  final double barSpace;
  final String title;
  final String unit;
  final Icon icon;
  final double maxChartValue;
  final double chartInterval;
  final List<String> leftTitleKey;
  final List<double> leftTitleValue;
  final List<String>? bottomTitleKey;
  final List<double> listChartValue;
  final List<Color> listColorGradient;
  final List<HeroChartModel> heroChartData;
  @override
  State<StatefulWidget> createState() => DashboardHeroChartState();
}

class DashboardHeroChartState extends State<DashboardHeroChart> {
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

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
            const SizedBox(width: 16),
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(width: 4),
            Text(
              '(${widget.unit})',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.black38),
            ),
          ],
        ),
        const SizedBox(height: 38),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: widget.maxChartValue,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black87.withValues(alpha: 0.7),
                  tooltipMargin: 8,
                  tooltipPadding: const EdgeInsets.only(
                    left: 16,
                    top: 12,
                    right: 16,
                    bottom: 8,
                  ),
                  getTooltipItem:
                      (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          'Date: ${widget.heroChartData[groupIndex].date}\nBatch: ${widget.heroChartData[groupIndex].batch}\nTotal: ${rod.toY.toStringAsFixed(0)} ${widget.unit}',
                          textAlign: TextAlign.start,
                          const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        );
                      },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      touchedGroupIndex = -1;
                      return;
                    }
                    touchedGroupIndex =
                        barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: widget.bottomTitleKey != null
                      ? SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                        )
                      : const SideTitles(showTitles: false),
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
              borderData: FlBorderData(show: false),
              barGroups: showingChartGroups(),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff7589a2), fontSize: 12);

    String text = '';
    int val = widget.leftTitleValue.indexWhere(
      (element) => element.toDouble() == value,
    );
    if (val != -1) {
      String key = widget.leftTitleKey[val];
      text = key;
    }

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff7589a2), fontSize: 12);

    String text = '';
    if (value.toInt() < widget.bottomTitleKey!.length) {
      text = widget.bottomTitleKey![value.toInt()];
    } else {
      text = '';
    }

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      space: 4,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, {bool isTouched = false}) {
    return BarChartGroupData(
      barsSpace: widget.barSpace,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          width: widget.barWidth,
          borderRadius: BorderRadius.circular(4),
          gradient: !isTouched
              ? LinearGradient(
                  colors: widget.listColorGradient,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              : LinearGradient(
                  colors: [
                    widget.listColorGradient[0].withAlpha(80),
                    widget.listColorGradient[0].withAlpha(80),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingChartGroups() {
    List<BarChartGroupData> items = [];

    widget.listChartValue.asMap().forEach((index, value) {
      items.add(
        makeGroupData(index, value, isTouched: index == touchedGroupIndex),
      );
    });

    return items;
  }
}
