import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/utils/chart_data.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Penjualan Hari Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
        const SizedBox(height: 12),
        SizedBox(height: 180, child: LineChart(ChartData.lineChartData())),
        const Center(child: Text('2025', style: TextStyle(fontSize: 12, color: AppColors.azura))),
      ],
    );
  }
}