import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kasir/utils/chart_data.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(ChartData.barChartData()),
    );
  }
}