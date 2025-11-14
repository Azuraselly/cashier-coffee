import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ChartData {
  static LineChartData lineChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0, maxX: 6, minY: 0, maxY: 50,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 5), FlSpot(1, 12), FlSpot(2, 18),
            FlSpot(3, 25), FlSpot(4, 35), FlSpot(5, 42), FlSpot(6, 45),
          ],
          isCurved: true,
          gradient: LinearGradient(colors: [AppColors.azura, AppColors.azura]),
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [AppColors.azura.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  static BarChartData barChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10, color: Colors.black)),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: [
        _makeGroup(0, 12, 20),
        _makeGroup(1, 8, 12),
        _makeGroup(2, 10, 15),
        _makeGroup(3, 35, 10),
        _makeGroup(4, 28, 8),
        _makeGroup(5, 22, 12),
        _makeGroup(6, 38, 5),
      ],
    );
  }

  static BarChartGroupData _makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: AppColors.azura.withOpacity(0.6), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
        BarChartRodData(toY: y1 + y2, color: AppColors.azura, width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      ],
    );
  }
}